//
//  UIApplication+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/24.
//

import Foundation
import UIKit
public extension UIApplication {
    var lastPresentedViewController:UIViewController? {
        var vc = UIApplication.shared.keyWindow?.rootViewController
        while vc?.presentedViewController != nil {
            vc = vc?.presentedViewController
        }
        return vc
    }
}
