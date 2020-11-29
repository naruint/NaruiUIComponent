//
//  NaruCirclePointView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/26.
//

import UIKit

@IBDesignable
/** 동그라미 로 표시하는 난이도*/
public class NaruCirclePointView: UIView {

    @IBInspectable var maxLevel:Int = 3
    @IBInspectable var currentLevel:Int = 1
    @IBInspectable var offColor:UIColor = .gray
    @IBInspectable var onColor:UIColor = .red
    @IBInspectable var circleSize:CGFloat = 7
    @IBInspectable var padding:CGFloat = 4

    var colors:[UIColor] {
        var result:[UIColor] = []
        for i in 0..<maxLevel {
            let alpha:CGFloat = 1.0 - CGFloat(i) * (1.0 / (CGFloat(maxLevel) * 2.0))
            let newColor = onColor.cgColor.copy(alpha: alpha)!
            result.append(UIColor(cgColor: newColor))
        }
        return result.reversed()
    }
    
    public var level:Int {
        set {
            currentLevel = newValue
        }
        get {
            return currentLevel
        }
    }
    
    public override func draw(_ rect: CGRect) {
        print("maxLevel : \(maxLevel), currentLevel: \(currentLevel)")
        let y = rect.size.height / 2 - circleSize / 2
        for i in 0..<maxLevel {
            let x = circleSize * CGFloat(i) + padding * CGFloat(i)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: circleSize, height: circleSize)).cgPath
            if i > currentLevel {
                shapeLayer.fillColor = offColor.cgColor
            } else {
                shapeLayer.fillColor = colors[i].cgColor
            }
            layer.addSublayer(shapeLayer)
        }
        
    }
}
