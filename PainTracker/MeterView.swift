//
//  MeterView.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-09-05.
//  Copyright © 2019 Kriang. All rights reserved.
//

import SwiftUI

struct MeterView : View {
    
    var meterValue : CGFloat {
        didSet {
             self.previousValue = meterValue
        }
    }
    private(set) var previousValue : CGFloat = 0
    
    let size = CGSize.init(width: 100.0, height: 360.0)

    var body: some View {
        ZStack {
            ZStack (alignment: .bottom) {
                Rectangle()
                    .frame(width:size.width, height: size.height + 1.5, alignment: .center)
                    .foregroundColor(Color(hexValue: ALMOND_COLOR))
                Rectangle()
                    .frame(width: size.width, height: meterValue * self.size.height, alignment: .center)
                    .foregroundColor(Color(hexValue: COPPER_PENNY_COLOR))
            }
            .cornerRadius(30)
            SeperatorLinesBlock(area: size, sections: 10)
        }
    }
}

// MARK: Helper views

struct SeperatorLinesBlock : View {
        
    var area: CGSize
    var sections: Int
    var lineWeight: CGFloat
    
    let lineColor = Color(hexValue: ALMOND_COLOR).lighten(0.4)
    
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
                    .foregroundColor(self.lineColor)
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
//struct MeterView_Previews : PreviewProvider {
//    static var previews: some View {
//        MeterView()
//    }
//}
#endif

