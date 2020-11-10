//
//  UIColorExtension.swift
//  Cafe24Front
//
//  Created by jychoi04_T1 on 2017. 9. 6..
//  Copyright © 2017년 jychoi04_T1. All rights reserved.
//

import UIKit

/// UIColor에서 색 가져오기 익스텐션
extension UIColor {
    
    static let _fDivin: Float = 255
    static let _AlphaDivin: Float = 100
    
    /// RGB값을 UIColor로 변경
    static func RGBA(_ red:Float, _ green:Float, _ blue:Float, _ alpha:Float = 100) -> UIColor {
        
        var tmpRed   = red   / UIColor._fDivin
        var tmpGreen = green / UIColor._fDivin
        var tmpBlue  = blue  / UIColor._fDivin
        var tmpAlpha = alpha / UIColor._AlphaDivin
        
        if tmpRed > 1 {
            tmpRed = 1.0
        }
        
        if tmpGreen > 1 {
            tmpGreen = 1.0
        }
        
        if tmpBlue > 1 {
            tmpBlue = 1.0
        }
        
        if tmpAlpha > 1 {
            tmpAlpha = 1.0
        }
        
        let colorSpace    = CGColorSpace(name:CGColorSpace.sRGB)!
        let rgbaLikeArray = [CGFloat(tmpRed), CGFloat(tmpGreen), CGFloat(tmpBlue), CGFloat(tmpAlpha) ]
        let cgColorWithColorSpace = CGColor(colorSpace: colorSpace, components: rgbaLikeArray)!
        let makeCgcolor  = cgColorWithColorSpace.converted(to: colorSpace, intent: .absoluteColorimetric, options: nil)!
        
        let rtnColor = UIColor(cgColor: makeCgcolor)

        return rtnColor
    }
    
    /// RGB값을 UIColor로 변경
    static func RGB(_ red:Float, _ green:Float, _ blue:Float) -> UIColor {
        
        return UIColor.RGBA(red, green, blue)
    }
    
    /// comment : 핵사 텍스트를 UIColor로 변환
    static func fromHex(_ hexString: String, alpha: CGFloat = 100) -> UIColor {
        
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        
        if let hex = Int(formatted, radix: 16) {
            
            let red   = Float((hex & 0xFF0000) >> 16)
            let green = Float((hex & 0x00FF00) >> 8)
            let blue  = Float((hex & 0x0000FF) >> 0)
            
            return UIColor.RGBA(red, green, blue, Float(alpha ))
        }
        else {
            
            return .black
        }
    }
}
