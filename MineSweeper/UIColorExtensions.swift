//
//  UIColorExtensions.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/28/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var seraphLightBlack: UIColor {
        return UIColor(hex: 0x161823)
    }
    class var seraphDarkBlack: UIColor {
        return UIColor(hex: 0x1B1B1B)
    }
    class var seraphDarkPurple: UIColor {
        return UIColor(hex: 0x8A35F2)
    }
    class var seraphHotPink: UIColor {
        return UIColor(hex: 0xFF2366)
    }
    
    class var seraphPurplePink: UIColor {
        return UIColor(hex: 0xFD51D9)
    }
    
    class var seraphRedPink: UIColor {
        return UIColor(hex: 0xE92C81)
    }
    
    class var seraphLightBlue: UIColor {
        return UIColor(hex: 0x56B2BA)
    }
    
    class var seraphDarkBlue: UIColor {
        return UIColor(hex: 0x0B78E3)
    }
    
    class var seraphYellow: UIColor {
        return UIColor(hex: 0xFACE15)
    }
    
    class var seraphLightPurple: UIColor {
        return UIColor(hex: 0x8D4DE8)
    }
    class var seraphGreen: UIColor {
        return UIColor(hex: 0x7ED321)
    }
    
    class var seraphOrange: UIColor {
        return UIColor(hex: 0xF8A30D)
    }
    class var seraphRed: UIColor {
        return UIColor(hex: 0xD83133)
    }
    class var seraphLightWhite: UIColor {
        return UIColor(hex: 0xFFFFFF, alpha: 0.1)
    }
    
    
    convenience init(hex: Int) {
        self.init(
            hexRed: (hex >> 16) & 0xFF,
            hexGreen: (hex >> 8) & 0xFF,
            hexBlue: hex & 0xFF,
            alpha: 1.0
        )
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        self.init(
            hexRed: (hex >> 16) & 0xFF,
            hexGreen: (hex >> 8) & 0xFF,
            hexBlue: hex & 0xFF,
            alpha: alpha
        )
    }
    
    convenience init(hexRed: Int, hexGreen: Int, hexBlue: Int, alpha: CGFloat) {
        assert(hexRed >= 0 && hexRed <= 255, "Invalid red component")
        assert(hexGreen >= 0 && hexGreen <= 255, "Invalid green component")
        assert(hexBlue >= 0 && hexBlue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(hexRed) / 255.0, green: CGFloat(hexGreen) / 255.0, blue: CGFloat(hexBlue) / 255.0, alpha: alpha)
    }
}
