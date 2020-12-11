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
    
    /** 라운드 이미지 만들기 (라운드 BG 버튼 만들기 용)*/
    func roundImage(cornerRadius:CGFloat, size:CGSize, strockColor:UIColor? = nil, strockWidth:CGFloat = 0)->UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
     
        let path = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint(x: strockWidth, y: strockWidth),
                                size: CGSize(width: size.width - strockWidth * 2, height: size.height - strockWidth * 2)
            ), cornerRadius: cornerRadius)
        
        self.setFill()
        path.fill()
        if let color = strockColor {
            color.setStroke()
            path.lineWidth = strockWidth
            path.stroke()
        }
        ctx.addPath(path.cgPath)
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius), resizingMode: .stretch)
    }
}
