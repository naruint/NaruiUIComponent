//
//  NaruCirclePointView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/26.
//

import UIKit

//@IBDesignable
/** 동그라미 로 표시하는 난이도*/
public class NaruCirclePointView: UIView {

    @IBInspectable var currentLevel:Int = 1
    @IBInspectable var circleSize:CGFloat = 7
    @IBInspectable var padding:CGFloat = 4

    public var onColors:[UIColor] = [.red,.green,.blue]
    public var offColors:[UIColor] = [.gray,.gray,.gray]
    
    var maxLevel:Int {
        onColors.count
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
        let y = rect.size.height / 2 - circleSize / 2
        for i in 0..<maxLevel {
            let x = circleSize * CGFloat(i) + padding * CGFloat(i)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: circleSize, height: circleSize)).cgPath
            if i > currentLevel {
                shapeLayer.fillColor = offColors[i].cgColor
            } else {
                shapeLayer.fillColor = onColors[i].cgColor
            }
            layer.addSublayer(shapeLayer)
        }
        
    }
}
