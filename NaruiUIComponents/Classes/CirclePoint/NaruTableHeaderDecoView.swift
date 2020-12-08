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
    
    public var circleColor: UIColor? = .black {
        didSet {
            redraw()
        }
    }
    
    public var font:UIFont = UIFont.boldSystemFont(ofSize: 14) {
        didSet {
            redraw()
        }
    }
    
    public var textColor:UIColor = .black {
        didSet {
            redraw()
        }
    }
    
    public func set(style:Style,
                    text:String?,
                    circleColor:UIColor?,
                    font:UIFont = UIFont.boldSystemFont(ofSize: 14),
                    textColor:UIColor = .black,
                    dashDistance:CGFloat = 10) {
        self.style = style
        self.text = text
        self.circleColor = circleColor
        self.font = font
        self.textColor = textColor
        self.dashDistance = dashDistance
    }
        

    private func redraw() {
        for layer in layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        draw(bounds)
    }

    public override func draw(_ rect: CGRect) {
        func drawCircle(size:CGFloat, color:UIColor?) {
            let shapeLayer = CAShapeLayer()
            if let color = color {
                shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - size / 2, y: bounds.midY - size / 2, width: size, height: size)).cgPath
                shapeLayer.fillColor = color.cgColor
            } else {
                shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - 3, y: bounds.midY - 3, width: 6, height: 6)).cgPath
                shapeLayer.fillColor = UIColor.black.cgColor
            }
            layer.addSublayer(shapeLayer)
        }
        
        func drawDot(color:UIColor) {
            let max = Int(bounds.height / dashDistance / 2 - 3)
            func drawline(bottom:Bool) {
                let x:CGFloat = CGFloat(bounds.midX - 1)
                for i in 0...max  {
                    let shapeLayer = CAShapeLayer()
                    var y:CGFloat = CGFloat(i) * dashDistance + dashDistance/2
                    if bottom == false {
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
            label.font = font
            label.textColor = textColor
            label.sizeToFit()
            label.center = CGPoint(x: bounds.midX, y: bounds.midY)
            label.textAlignment = .center
            layer.addSublayer(label.layer)
        } else {
            drawCircle(size: 11, color: circleColor)
            if circleColor != nil {
                drawCircle(size: 4, color: .white)
            }
        }
    }
}

