//
//  NaruDotLineView.swift
//  NaruiUIComponents
//
//  Created by Changyul Seo on 2020/11/29.
//

import UIKit

class NaruDotLineView: UIView {

    @IBInspectable var dashDistance:CGFloat = 10
    @IBInspectable var paddingTop:CGFloat = 10
    @IBInspectable var paddingBottom:CGFloat = 10
    @IBInspectable var dotSize:CGFloat = 2
    override func draw(_ rect: CGRect) {
        func drawDot(color:UIColor) {
            let max = Int((bounds.height - paddingTop - paddingBottom) / dashDistance )
            let x:CGFloat = CGFloat(bounds.midX - 1)
            for i in 0...max  {
                let shapeLayer = CAShapeLayer()
                let y:CGFloat = CGFloat(i) * dashDistance + paddingTop
                shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: x - dotSize / 2, y: y - dotSize / 2, width: dotSize, height: dotSize)).cgPath
                shapeLayer.fillColor = color.cgColor
                layer.addSublayer(shapeLayer)
            }
        }
        drawDot(color: .black)
        backgroundColor = .clear
    }

}
