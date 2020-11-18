//
//  String+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/05.
//

import Foundation
import AlamofireImage

public extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
    
    var isValidEmail:Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func getDate(format:String = "yyyy-MM-dd HH:mm:ss")->Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    /** 필수 입력 점 찍어서 attributedString 만들기*/
    func makeRequiredAttributeString(textColor:UIColor, pointColor:UIColor, height:CGFloat)->NSAttributedString {
        let str = NSMutableAttributedString()
        str.append(NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor : textColor]))
        let attachment = NSTextAttachment()
        attachment.image = pointColor.circleImage(diameter: 3)
        attachment.bounds = CGRect(x: 5, y: height / 2 , width: 3, height: 3)
        str.append(NSAttributedString(attachment: attachment))
        return str as NSAttributedString
    }
}
