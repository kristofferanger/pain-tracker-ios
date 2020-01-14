//
//  ColorHelpers.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-09-04.
//  Copyright © 2019 Kriang. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// Colors generated from: https://coolors.co/595758-fd5800-eed7c5-ffeef2-ffe4f3

let DAVYS_GRAY_COLOR = 0x595758ff
let WILLPOWER_ORANGE_COLOR = 0xfd5800ff
let ALMOND_COLOR = 0xeed7c5ff
let LAVENDER_BLUCH_COLOR = 0xffeef2ff
let PINK_LACE_COLOR = 0xffe4f3ff


// MARK: color helpers

extension Color {
    
    init(hexValue hex: Int) {
        let components = Color.componentsFrom(hexNumber: hex)
        self = Color(.sRGB, red: Double(components.r), green: Double(components.g), blue: Double(components.b), opacity: 1)
    }

    func lighten(_ value: Double) -> Color {
        let acceptableValue = max(-1.0, min( 1.0, value))
        let white = acceptableValue > 0 ? 1.0 : 0.0
        let opacity = abs(acceptableValue)
        
        return self + Color(.sRGB, white: white, opacity: opacity)
    }
    
    static func +(lhs: Color, rhs: Color) -> Color {
        return lhs.blend(withColor: rhs)
    }
    
    func blend(withColor color: Color) -> Color {
        
        let selfComponents = self.components()
        let blendingColorComponents = color.components()
        let alpha = blendingColorComponents.a
        
        let r  = Double(alpha * blendingColorComponents.r + (1 - alpha) * selfComponents.r)
        let g = Double(alpha * blendingColorComponents.g + (1 - alpha) * selfComponents.g)
        let b = Double(alpha * blendingColorComponents.b + (1 - alpha) * selfComponents.b)
        
        return Color(red: r, green: g, blue: b)
    }
    
    func uiColor() -> UIColor {
        let components = Color.componentsFrom(hexString: self.description)
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
    
    // MARK: dynamic colors
    
    @Environment(\.colorScheme) static var colorScheme: ColorScheme

    static func backgroundColor() -> Color {
        return colorScheme == .dark ? Color(hexValue: ALMOND_COLOR).lighten(-0.1) : Color(hexValue: ALMOND_COLOR).lighten(0.7)
    }
    
    
    // MARK: private methods

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        return Color.componentsFrom(hexString: self.description)
    }
    
    private static func componentsFrom(hexString: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        return componentsFrom(hexNumber: Int(hexNumber))
    }
    
    private static func componentsFrom(hexNumber: Int) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        var r: CGFloat = 0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255
    
        return (r, g, b, a)
    }
}


