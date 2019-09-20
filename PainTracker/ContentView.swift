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
    
    @State private var meterValue = (current: DEFAULT_HEIGHT, previous: DEFAULT_HEIGHT) {
        didSet {
            // when value out-of-bounds use the cropped value instead
            if let value = croppedPercentValue(meterValue.current) {
                meterValue.current = value
            }
        }
    }
    
    private func croppedPercentValue<T : Comparable & Numeric>(_ value: T) -> T? {
        let croppedValue = min(1, max(0, value))
        return value == croppedValue ? nil : croppedValue
    }
    
    var body: some View {
        
        let meterView = MeterView(meterValue: meterValue.current)
        
        return ZStack {
            Rectangle()
                .foregroundColor(Color(hexValue: ALMOND_COLOR).lighten(0.7))
            VStack (spacing: 10) {
                Text("Markera din nivå av smärta just nu på en skala mellan 1 och 10.")
                    .padding([.leading, .trailing], 40)
                Text(String(format:"%.1f", self.meterValue.current * 10))
                    .font(.largeTitle)
                    .bold()
                meterView
            }
        }
        .edgesIgnoringSafeArea([.all])
        .gesture(DragGesture()
                   .onChanged() { gestureValue in
                       self.meterValue.current = self.meterValue.previous - gestureValue.translation.height/meterView.size.height
                   }
                   .onEnded { gestureValue in
                       self.meterValue.previous = self.meterValue.current
               })
    }
}




#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
