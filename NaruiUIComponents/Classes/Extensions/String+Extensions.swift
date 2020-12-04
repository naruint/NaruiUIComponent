//
//  String+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/05.
//

import Foundation
import AlamofireImage
import CommonCrypto

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
    
    var sha256:String {
        func digest(input : NSData) -> NSData {
            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
            var hash = [UInt8](repeating: 0, count: digestLength)
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            return NSData(bytes: hash, length: digestLength)
        }
        
        func hexStringFromData(input: NSData) -> String {
            var bytes = [UInt8](repeating: 0, count: input.length)
            input.getBytes(&bytes, length: input.length)
            
            var hexString = ""
            for byte in bytes {
                hexString += String(format:"%02x", UInt8(byte))
            }
            return hexString
        }
        
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    var sha512:String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        if let data = data(using: String.Encoding.utf8) {
            let value =  data as NSData
            CC_SHA512(value.bytes, CC_LONG(data.count), &digest)
            
        }
        var digestHex = ""
        for index in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
    
}
