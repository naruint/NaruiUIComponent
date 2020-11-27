//
//  NaruTableHeaderDecoView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/26.
//

import Foundation
import UIKit
/** 테이블뷰 왼쪽에 세로로 대시라인 그리는 뷰 */
public class NaruTableHeaderDecoView: UIView {
    /** 스타일*/
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
    
    public var dashDistance: CGFloat = 10 {
        didSet {
            redraw()
        }
    }
    
    public func set(style:Style, text:String? , dashDistance:CGFloat = 10) {
        self.style = style
        self.text = text
        self.dashDistance = dashDistance
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
            let max = Int(bounds.height / dashDistance / 2 - 3)
            func drawline(bottom:Bool) {
                let x:CGFloat = CGFloat(bounds.midX - 1)
                for i in 0...max  {
                    let shapeLayer = CAShapeLayer()
                    var y:CGFloat = CGFloat(i) * dashDistance + dashDistance/2
                    if bottom {
                        y = bounds.height - y
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
