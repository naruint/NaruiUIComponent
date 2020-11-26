//
//  NaruTableHeaderDecoView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/26.
//

import Foundation
import UIKit

public class NaruTableHeaderDecoView: UIView {
    public enum Style {
        case start
        case middle
        case end
    }
    
    public var style : Style = .middle {
        didSet {
            redraw()
        }
    }
    
    public var text : String? = nil {
        didSet {
            redraw()
        }
    }
    
    private func redraw() {
        for layer in layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        draw(bounds)
    }

    public override func draw(_ rect: CGRect) {
        func drawCircle(size:CGFloat, color:UIColor) {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - size / 2, y: bounds.midY - size / 2, width: size, height: size)).cgPath
            shapeLayer.fillColor = color.cgColor
            layer.addSublayer(shapeLayer)
        }
        
        func drawDot(color:UIColor) {
            let max = Int(bounds.height / 10 / 2 - 3)
            func drawline(bottom:Bool) {
                for i in 0...max  {
                    let shapeLayer = CAShapeLayer()
                    let x:CGFloat = CGFloat(bounds.midX - 1)
                    var y:CGFloat = CGFloat(i) * 10
                    if bottom {
                        y += bounds.midY + 30
                    }
                    shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: x , y: y, width: 2, height: 2)).cgPath
                    shapeLayer.fillColor = color.cgColor
                    layer.addSublayer(shapeLayer)
                }
            }
            switch style {
            case .start:
                drawline(bottom: false)
            case .middle:
                drawline(bottom: true)
                drawline(bottom: false)
            case .end:
                drawline(bottom: true)
            }
            
        }
        drawDot(color: .black)
        if let txt = text {
            let label = UILabel()
            label.text = txt
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.textColor = .black
            label.sizeToFit()
            label.center = CGPoint(x: bounds.midX, y: bounds.midY)
            label.textAlignment = .center
            layer.addSublayer(label.layer)
        } else {
            drawCircle(size: 11, color: .black)
            drawCircle(size: 4, color: .white)
        }
    }
}

