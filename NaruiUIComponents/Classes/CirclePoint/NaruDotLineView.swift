//
//  NaruDotLineView.swift
//  NaruiUIComponents
//
//  Created by Changyul Seo on 2020/11/29.
//

import UIKit

public class NaruDotLineView: UIView {
    @IBInspectable var dashDistance:CGFloat = 10
    @IBInspectable var paddingTop:CGFloat = 10
    @IBInspectable var paddingBottom:CGFloat = 10
    @IBInspectable var paddingLeft:CGFloat = 10
    @IBInspectable var paddingRight:CGFloat = 10
    @IBInspectable var dotSize:CGFloat = 2
    @IBInspectable var isHorizontal:Bool = false
    @IBInspectable var dotColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    public override func draw(_ rect: CGRect) {
        drawDot()
        backgroundColor = .clear
    }
    
    func drawDot() {
        for slayer in layer.sublayers ?? [] {
            slayer.removeFromSuperlayer()
        }
        
        var max = Int((bounds.height - paddingTop - paddingBottom) / dashDistance )
        if isHorizontal {
            max = Int((bounds.width - paddingLeft - paddingRight) / dashDistance )
        }
        if max < 0 {
            return
        }
        for i in 0...max  {
            let shapeLayer = CAShapeLayer()
            var x:CGFloat = CGFloat(bounds.midX - dotSize / 2)
            var y:CGFloat = CGFloat(i) * dashDistance + paddingTop
            if isHorizontal {
                x = CGFloat(i) * dashDistance + paddingLeft
                y = CGFloat(bounds.midY - 1)
            }

            shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: x - dotSize / 2, y: y - dotSize / 2, width: dotSize, height: dotSize)).cgPath
            shapeLayer.fillColor = dotColor.cgColor
            layer.addSublayer(shapeLayer)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        drawDot()
    }

}
