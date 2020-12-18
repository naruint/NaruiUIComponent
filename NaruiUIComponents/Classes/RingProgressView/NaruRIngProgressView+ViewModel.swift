//
//  NaruRIngProgressView+ViewModel.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/24.
//

import Foundation
extension NaruRingProgressView {
    public struct ViewModel {
        public var secondLabelText:String
        public var progress:Float
        public var firstLabelText:String {
            let p = Int(progress * 100)
            return "\(p)"
        }
        
        public let forgroundColor:UIColor
        public let ringBackgrouncColor:UIColor
        public init(secondLabelText:String, progress:Float, forgroundColor:UIColor, ringBackgrouncColor:UIColor?) {
            self.secondLabelText = secondLabelText
            self.progress = progress
            self.forgroundColor = forgroundColor
            if let color = ringBackgrouncColor {
                self.ringBackgrouncColor = color
            } else {
                self.ringBackgrouncColor = forgroundColor.withAlphaComponent(0.2)
            }
        }
    }

 
}
