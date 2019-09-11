//
//  MeterView.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-09-05.
//  Copyright © 2019 Kriang. All rights reserved.
//

import SwiftUI

struct MeterView : View {
        
    @State private var meterValue : CGFloat = 0.3
    
    let size = CGSize.init(width: 100.0, height: 360.0)
    
    var body: some View {
        ZStack {
            ZStack (alignment: .bottom) {
                Rectangle()
                    .frame(width:size.width, height: size.height, alignment: .center)
                    .foregroundColor(Color(hexValue: ALMOND_COLOR))
                Rectangle()
                    .frame(width: size.width, height: meterValue*size.height, alignment: .center)
                    .foregroundColor(Color(hexValue: COPPER_PENNY_COLOR))
            }
            .gesture( DragGesture()
                .onChanged {
                    self.meterValue -= $0.translation.height/self.size.height

            })
            .cornerRadius(30)
            SeperatorLinesBlock(area: size, sections: 10)
        }
    }
}

// MARK: Helper views

struct SeperatorLinesBlock : View {
        
    var area: CGSize
    var lineWeight: CGFloat
    var sections: Int
    
    let color = Color(hexValue: ALMOND_COLOR).lighten(0.4)
    
    // computed properties
    private var padding : CGFloat {
        return area.height/CGFloat(2*sections+1)
    }
    
    // body
    var body : some View {
        VStack(spacing: 0) {
            ForEach(0..<sections-1, id: \.self) { _ in
                Rectangle()
                    .frame(width: self.area.width, height: self.lineWeight)
                    .foregroundColor(self.color)
                    .padding(self.padding)
            }
        }
    }
}


extension SeperatorLinesBlock {
    
    init(area: CGSize, sections: Int) {
        self.lineWeight = 1.5
        self.area = area
        self.sections = max(1, sections)
    }
}

#if DEBUG
struct MeterView_Previews : PreviewProvider {
    static var previews: some View {
        MeterView()
    }
}
#endif

