//
//  ContentView.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-09-04.
//  Copyright © 2019 Kriang. All rights reserved.
//

import SwiftUI

let DEFAULT_HEIGHT : CGFloat = 1/3


struct ContentView : View {
    
    @State private var previousMeterValue: CGFloat = DEFAULT_HEIGHT
    @State private var meterValue: CGFloat = DEFAULT_HEIGHT {
        didSet {
            // when value out-of-bounds use the cropped value instead
            if let value = croppedPercentValue(meterValue) {
                meterValue = value
            }
        }
    }
    
    
    
    var body: some View {
        
        let meterView = MeterView(meterValue: meterValue)
        
        return VStack (spacing: 10) {
            Text("Markera din nivå av smärta just nu på en skala mellan 1 och 10.")
                .padding([.leading, .trailing], 40)
            Text(String(format:"%.1f", self.meterValue * 10))
                .font(.largeTitle)
                .bold()
            meterView
        }
        .gesture(DragGesture()
            .onChanged() { gestureValue in
                self.meterValue = self.previousMeterValue - gestureValue.translation.height/meterView.size.height
            }
            .onEnded { gestureValue in
                self.previousMeterValue = self.meterValue
        })
    }
    
    private func croppedPercentValue<T : Comparable & FloatingPoint>(_ value: T) -> T? {
        let croppedValue = min(1, max(0, value))
        return value == croppedValue ? nil : croppedValue
    }
}

@propertyWrapper struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
