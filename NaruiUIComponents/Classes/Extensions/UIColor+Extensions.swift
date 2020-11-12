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
}
