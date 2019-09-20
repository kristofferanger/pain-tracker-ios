//
//  ColorHelpers.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-09-04.
//  Copyright © 2019 Kriang. All rights reserved.
//

import Foundation
import SwiftUI

// Colors generated from: https://coolors.co/595758-fd5800-eed7c5-ffeef2-ffe4f3

let DAVYS_GRAY_COLOR = 0x595758
let WILLPOWER_ORANGE_COLOR = 0xfd5800
let ALMOND_COLOR = 0xeed7c5
let LAVENDER_BLUCH_COLOR = 0xffeef2
let PINK_LACE_COLOR = 0xffe4f3


// MARK: color helpers

extension Color {
    
    init(hexValue hex: Int) {
        let components = (
            red: Double((hex >> 16) & 0xff) / 255.0,
            green: Double((hex >> 08) & 0xff) / 255.0,
            blue: Double((hex >> 00) & 0xff) / 255.0
        )
        self = Color.init(.sRGB, red: components.red, green: components.green, blue: components.blue, opacity: 1)
    }

    func lighten(_ value: Double) -> Color {
        
        let acceptableValue = max(-1.0, min( 1.0, value))
        let white = acceptableValue > 0 ? 1.0 : 0.0
        let opacity = abs(acceptableValue)
        
        return self + Color.init(.sRGB, white: white, opacity: opacity)
    }
    
    func blend(withColor color: Color = .clear) -> Color {
        
        let selfComponents = self.components()
        let blendingColorComponents = color.components()
        let alpha = blendingColorComponents.a
        
        let r  = Double(alpha * blendingColorComponents.r + (1 - alpha) * selfComponents.r)
        let g = Double(alpha * blendingColorComponents.g + (1 - alpha) * selfComponents.g)
        let b = Double(alpha * blendingColorComponents.b + (1 - alpha) * selfComponents.b)
        
        return Color.init(red: r, green: g, blue: b)
    }

    // plus-operator for convenience blend()
    static func + (lhs: Color, rhs: Color) -> Color {
        return lhs.blend(withColor: rhs)
    }
    
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        
        var r: CGFloat = 0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}


