//
//  UIColor+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/12.
//

import UIKit
public extension UIColor {
    var image:UIImage {
        return UIImage(color: self)
    }
    
    /** 서클 이미지 만들기*/
    func circleImage(diameter: CGFloat) -> UIImage {
        return UIImage(diameter: diameter, fillColor: self)
    }
    
    /** 2중 서클 이미지 만들기*/
    func circleImage(diameter:CGFloat, innerColor:UIColor, innerDiameter:CGFloat) -> UIImage {
        return UIImage(diameter: diameter, innerDiameter: innerDiameter, outColor: self, innerColor: innerColor)
    }
    
    /** 라운드 이미지 만들기 (라운드 BG 버튼 만들기 용)*/
    @available(*, deprecated, renamed: "UIImage()", message: "UIImage(size...)로 수정되었습니다.")
    func roundImage(cornerRadius:CGFloat, size:CGSize, strockColor:UIColor? = nil, strockWidth:CGFloat = 0)->UIImage {
        return UIImage(size: size, fillColor: self, cornerRadius: cornerRadius, strockColor: strockColor, strockWidth: strockWidth)
    }
}
