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

struct DetailView: View {
    
    @State private var meterValue = (current: DEFAULT_METER_VALUE, previous: DEFAULT_METER_VALUE) {
        didSet {
            // when value is out-of-bounds use the clamped value instead
            if let value = meterValue.current.clampedValue {
                meterValue.current = value
            }
        }
    }
    
    @State private var painDimensionIndex: Int = 0
    @State private var datePickerShowing: Bool = false
    @State private var currentDate: Date = Date()
    
    @Binding var isShowing: Bool
    
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
        
        return ZStack (alignment: .center) {
                backgroundColor()
                VStack (spacing: 10) {
                    HStack {
                        Button(action: {
                            self.isShowing.toggle()
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
                            self.datePickerShowing.toggle()
                        })
                        {
                            Text(dateFormatter.string(from:self.currentDate).uppercased())
                                .font(.caption)
                                .foregroundColor(.primary)
                        }.sheet(isPresented: $datePickerShowing) {
                            ModalView(date: self.$currentDate)
                        }
                        
                    }
                    TextBlock(counterValue: self.meterValue.current, headerText: headerText())
                        .fixedSize(horizontal: false, vertical: true)
                    ZStack() {
                        Rectangle()
                            .fill(backgroundColor())
                        meterView
                    }.gesture(dragGesture)
                    ButtonBlock(currentIndex: $painDimensionIndex)
                }
                .padding(.all, 40)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func headerText() -> String {
        switch painDimensionIndex {
        case 0:
            return "Set your level of pain on a scale between 1 and 10." // Markera din nivå av smärta på en skala mellan 1 och 10."
        case 1:
            return "Set the duration of the pain in number of hours." //"Markera hur länge under dygnet du har haft smärta, i antal timmar."
        default:
            return "Illigal choice" //"Ogiltigt val."
        }
    }
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    private func backgroundColor() -> Color  {
        return colorScheme == .dark ? Color(hexValue: ALMOND_COLOR).lighten(-0.1) : Color(hexValue: ALMOND_COLOR).lighten(0.7)
    }
    
    private func croppedPercentValue<T : Comparable & Numeric>(_ value: T) -> T? {
        let croppedValue = min(1, max(0, value))
        return value == croppedValue ? nil : croppedValue
    }
}


struct ButtonBlock : View {
    
    @Binding var currentIndex : Int
    
    var body: some View {
        HStack() {
            Image(systemName: "message")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(Color.secondary)
                .frame(width: 25)
            Spacer()
            Picker(selection: $currentIndex, label: Text("Dimension")) {
                ForEach(0 ..< PainDimension.allCases.count) {
                    Text(PainDimension.allCases[$0].rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 170)
            Spacer()
            Image(systemName: "bandage")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(Color.secondary)
                .frame(width: 25)
        }.padding()
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

struct ModalView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentation
    @Binding var date: Date

    var body: some View {
        ZStack {
            backgroundColor()
            VStack {
                Text("Select a date")
                DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                    Text("")
                }
                Button("Done") {
                    self.presentation.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func backgroundColor() -> Color  {
        return colorScheme == .dark ? Color(hexValue: ALMOND_COLOR).lighten(-0.1) : Color(hexValue: ALMOND_COLOR).lighten(0.7)
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

