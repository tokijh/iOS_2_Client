//
//  UIColor+Extensions.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/27.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

public typealias Color = UIColor

extension Color {
    
    class var textBlack: Color { return Color(named: "text")! }
    
    // MARK: Red
    open class var bubbleBackgroudColor: Color { return Color(named: "bubbleBackgroudColor")! }
    open class var mainBackgroundColor: Color { return Color(named: "mainBackgroundColor")! }
    open class var main: Color { return Color(named: "main")! }
    open class var tabBarBackground: Color { return Color(named: "TabBarBackground")! }
    open class var tabBarTint: Color { return Color(named: "TabBarTint")! }
    open class var tabBarUnselectedTint: Color { return Color(named: "TabBarUnselectedTint")! }
    open class var recordCellBackgroundColor: Color { return Color(named: "recordCellBackgroundColor")! }
    
    // MARK: Quest
    class var questBackground: Color { return Color(named: "questBackground")! }
    class var questBackgroundTint: Color { return Color(named: "questBackgroundTint")! }
    class var questTint: Color { return Color(named: "questTint")! }
    class var trainingTint: Color { return Color(named: "trainingTint")! }
    class var routineTint: Color { return Color(named: "routineTint")! }

}

// MARK: - Initializers

public extension Color {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
        let d = CGFloat(255)
        return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
