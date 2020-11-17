//
//  UIButton+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/17.
//

import Foundation
import UIKit

extension UIButton {
    @IBInspectable var isUnderLine:Bool {
        set {
            if let title = self.title(for: .normal) {
                let attr = NSAttributedString(string: title,attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue])
                setAttributedTitle(attr, for: .normal)
            }
        }
        get {
            self.attributedTitle(for: .normal) != nil
        }
    }
}
