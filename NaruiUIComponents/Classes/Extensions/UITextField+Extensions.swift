//
//  UITextField+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/16.
//

import UIKit
import RxCocoa
import RxSwift

extension UITextField {
    func setClearButtonImage(image:UIImage) {
        if let clearButton = value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(image, for: .normal)
        }
    }    
}
