//
//  UIView+Extensoins.swift
//  UITest
//
//  Created by Changyeol Seo on 2020/10/12.
//

import Foundation
import UIKit
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    func finedView(nibName:String, id:String?)->UIView? {
        let instantiate = UINib(nibName: nibName,
              bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)
        if id == nil {
            return instantiate.first as? UIView
        }
        
        for a in instantiate {
            if id == (a as? UIView)?.restorationIdentifier {
                return a as? UIView
            }
        }
        return nil
    }

}
