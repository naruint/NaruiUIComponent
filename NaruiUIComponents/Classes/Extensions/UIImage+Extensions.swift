//
//  UIImage+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyul Seo on 2020/12/13.
//

import Foundation
import UIKit
fileprivate let nativeScale:CGFloat = UIScreen.main.nativeScale

public extension UIImage {
    struct GradientPoint {
       var location: CGFloat
       var color: UIColor
    }
    
    /** 그라데이션 라운드 이미지 만듭니다.*/
    convenience init(size: CGSize, gradientPoints: [GradientPoint], start:CGPoint, end:CGPoint, cornerRadius:CGFloat, strockColor:UIColor? = nil, strockWidth:CGFloat = 0) {
        let size = CGSize(width: size.width/nativeScale, height: size.height/nativeScale)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        let ctx = UIGraphicsGetCurrentContext()!
        let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(),
                                        colorComponents: gradientPoints.compactMap { $0.color.cgColor.components }.flatMap { $0 },
                                        locations: gradientPoints.map { $0.location },
                                        count: gradientPoints.count)!
        ctx.saveGState()
        let rect = CGRect(origin: CGPoint(x: strockWidth, y: strockWidth),
                          size: CGSize(width: size.width - strockWidth * 2, height: size.height - strockWidth * 2))
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.addClip()
        ctx.addPath(path.cgPath)
        ctx.drawLinearGradient(gradient,
                                   start: CGPoint(x: start.x * size.width, y: start.y * size.height),
                                   end: CGPoint(x: end.x * size.width, y: end.y * size.height),
                                   options: CGGradientDrawingOptions())
        
        if let color = strockColor {
            color.setStroke()
            path.lineWidth = strockWidth
            path.stroke()
        }
        ctx.addEllipse(in: rect)
    

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        let resultImage = image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius), resizingMode: .stretch).cgImage!
        self.init(cgImage: resultImage)
        defer { UIGraphicsEndImageContext() }
    }
    
    /** 단색 라운드 이미지 만듭니다.*/
    convenience init(size:CGSize, fillColor:UIColor, cornerRadius:CGFloat,strockColor:UIColor? = nil, strockWidth:CGFloat = 0) {
        let size = CGSize(width: size.width/nativeScale, height: size.height/nativeScale)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let path = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint(x: strockWidth, y: strockWidth),
                                size: CGSize(width: size.width - strockWidth * 2, height: size.height - strockWidth * 2)
            ), cornerRadius: cornerRadius)
        
        fillColor.setFill()
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
        let resultImage = img.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius), resizingMode: .stretch).cgImage!
        self.init(cgImage : resultImage)
        defer {
            UIGraphicsEndImageContext()
        }
    }
    
    /** 2중 서클 이미지 만들기*/
    convenience init(diameter:CGFloat, innerDiameter:CGFloat, outColor:UIColor, innerColor:UIColor) {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter/nativeScale, height: diameter/nativeScale), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter / nativeScale, height: diameter / nativeScale)
        ctx.setFillColor(outColor.cgColor)
        ctx.fillEllipse(in: rect)
        
        let a = (diameter - innerDiameter) / nativeScale / 2
        let innerRect = CGRect(x: a, y: a, width: innerDiameter/nativeScale, height: innerDiameter/nativeScale)
        ctx.setFillColor(innerColor.cgColor)
        ctx.fillEllipse(in: innerRect)
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: img.cgImage!)
    }
    
    /** 서클 이미지 만들기*/
    convenience init(diameter: CGFloat, fillColor:UIColor) {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter / nativeScale , height: diameter / nativeScale), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter / nativeScale, height: diameter / nativeScale)
        ctx.setFillColor(fillColor.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage:img.cgImage!)
    }
    
    /** 컬러값으로 이미지 만들기*/
    convenience init(color:UIColor, size:CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage:img.cgImage!)
    }
}
