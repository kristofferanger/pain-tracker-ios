//
//  DetailView.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-10-11.
//  Copyright © 2019 Kriang. All rights reserved.
//

import SwiftUI
import Combine

let DEFAULT_METER_VALUE : CGFloat = 1/3

class ContentViewModel: ObservableObject {
    @Published var meterValue = (current: DEFAULT_METER_VALUE, previous: DEFAULT_METER_VALUE) {
        didSet {
            // when value is out-of-bounds use the cropped value instead
            if let value = meterValue.current.clampedValue {
                meterValue.current = value
            }
        }
    }
}

enum PainDimension: String, CaseIterable  {
    case intensity = "Intensity" //"Intensitet"
    case duration =  "Duration" //"Varaktighet"
}

enum DragInfo {
    case inactive
    case active(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .active(let t):
            return t
        }
    }

    var isActive: Bool {
        switch self {
        case .inactive: return false
        case .active: return true
        }
    }
}

enum ActiveSheet {
   case datePicker, painKiller
}

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var userData: UserData
    
    @State private var meterValue = (current: DEFAULT_METER_VALUE, previous: DEFAULT_METER_VALUE) {
        didSet {
            // when value is out-of-bounds use the clamped value instead
            if let value = meterValue.current.clampedValue {
                meterValue.current = value
            }
        }
    }
    @State private var painDimensionIndex = 0
    
    @State private var sheetIsPresenting = false
    @State private var activeSheet: ActiveSheet = .datePicker
    
    @State private var currentDate = Date()
    
    @State private var message: String?
    @State private var selectedPainKillerId: Int?

    @GestureState private var dragInfo = DragInfo.inactive
    
    @FetchRequest(
        entity: PainItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PainItem.date, ascending: true)]
    ) var painItems: FetchedResults<PainItem>
    
//    @ObservedObject private var model = ContentViewModel()
    

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
        
    var body: some View {
        let meterView = MeterView(value: meterValue.current)
        let dragGesture = DragGesture()
                            .onChanged { gestureValue in
                                self.meterValue.current = self.meterValue.previous - gestureValue.translation.height/meterView.size.height
                            }
                            .onEnded { gestureValue in
                                self.meterValue.previous = self.meterValue.current
                            }
                            .updating($dragInfo) { (value, dragInfo, _) in
                                dragInfo = .active(translation: value.translation)
                            }
        
        return ZStack {
                Color.backgroundColor()
                VStack (spacing: 10) {
                    
                    // top section
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(Color.secondary)
                                .frame(width: 25)
                                .padding([.bottom, .top])
                        }
                        Spacer()
                        Button (action: {
                            self.activeSheet = .datePicker
                            self.sheetIsPresenting.toggle()
                        })
                        {
                            Text(dateFormatter.string(from:self.currentDate).uppercased())
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                    // titles
                    TextBlock(counterValue: self.meterValue.current, headerText: headerText())
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // meterview with gesture
                    ZStack() {
                        Rectangle()
                            .fill(Color.backgroundColor())
                        meterView
                    }.gesture(dragGesture)
                    
                    // bottom buttons
                    HStack() {
                        Image(systemName: message == nil ? "message" : "message.fill")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .foregroundColor(Color.secondary)
                            .frame(width: 25)
                        Spacer()
                        Picker(selection: $painDimensionIndex, label: Text("Dimension")) {
                            ForEach(0 ..< PainDimension.allCases.count) {
                                Text(PainDimension.allCases[$0].rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: 170)
                        Spacer()
                        
                        Button(action: {
                            self.activeSheet = .painKiller
                            self.sheetIsPresenting.toggle()
                        }) {
                            Image(systemName: selectedPainKillerId == nil ? "bandage" : "bandage.fill")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(Color.secondary)
                                .frame(width: 25)
                        }
                    }.padding()
                }
                .padding(.all, 40)
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $sheetIsPresenting) {
            if self.activeSheet == .datePicker {
                DateModalView(date: self.$currentDate)
            }
            else {
                TableView(selectedItemId: self.$selectedPainKillerId, data: self.userData.painKillers)
            }
        }
        .onDisappear {
            let painItem = PainItem(context: self.managedObjectContext)
            painItem.date = self.currentDate
            painItem.duration = 2
            painItem.level = Double(self.meterValue.current)
            painItem.medicineId = Int64(self.selectedPainKillerId ?? 0)
            painItem.message = self.message
            
            do {
                try self.managedObjectContext.save()
                print("Saved pain record: \(painItem.description)")
            } catch {
                // handle the Core Data error
            }
        }
    }
    
    private func headerText() -> String {
        switch painDimensionIndex {
        case 0:
            return "Set your level of pain on a scale between 1 and 10." // Markera din nivå av smärta på en skala mellan 1 och 10."
        case 1:
            return "Set the duration of the pain in number of hours of the day." //"Markera hur länge under dygnet du har haft smärta, i antal timmar."
        default:
            return "Illigal choice" //"Ogiltigt val."
        }
    }
    
    private func croppedPercentValue<T : Comparable & Numeric>(_ value: T) -> T? {
        let croppedValue = min(1, max(0, value))
        return value == croppedValue ? nil : croppedValue
    }
}

struct TextBlock : View {
    var counterValue : CGFloat
    var headerText : String
    
    var body: some View {
        VStack (spacing: 10) {
            Text(headerText)
            Text(String(format:"%.1f", counterValue * 10))
                .font(.largeTitle)
                .bold()
        }
    }
}

struct DateModalView: View {

    @Environment(\.presentationMode) var presentation
    @Binding var date: Date

    var body: some View {
        ZStack {
            Color.backgroundColor()
            VStack(alignment: .center) {
                Text("Select a date")
                DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                    .labelsHidden()
                Button("Done") {
                    self.presentation.wrappedValue.dismiss()
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

fileprivate extension Numeric where Self: Comparable {
    var clampedValue: Self? {
        get {
            let clampedValue = min(1, max(0, self))
            return self == clampedValue ? nil : clampedValue
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(isShowing: true)
//    }
//}

