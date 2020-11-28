//
//  UIColor+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/12.
//

import UIKit
public extension UIColor {
    var image:UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    /** 서클 이미지 만들기*/
    func circleImage(diameter: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(self.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()        
        return img
    }
    
    /** 2중 서클 이미지 만들기*/
    func circleImage(diameter:CGFloat, innerColor:UIColor, innerDiameter:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(self.cgColor)
        ctx.fillEllipse(in: rect)
        
        let a = (diameter - innerDiameter) / 2
        let innerRect = CGRect(x: a, y: a, width: innerDiameter, height: innerDiameter)
        ctx.setFillColor(innerColor.cgColor)
        ctx.fillEllipse(in: innerRect)
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img

    }
}
