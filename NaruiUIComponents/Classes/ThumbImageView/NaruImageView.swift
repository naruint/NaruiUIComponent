//
//  NaruImageView.swift
//  NaruiUIComponents
//
//  Created by Changyul Seo on 2020/11/29.
//

import UIKit
import Kingfisher

@IBDesignable
public class NaruImageView: UIView {
    public var isSelected:Bool = false {
        didSet {
            makeDropShadow()
        }
    }
    
    @IBInspectable var dimColor:UIColor = UIColor(white: 0, alpha: 0.15)
    @IBInspectable var gradientOvery:Bool = true {
        didSet {
            
            makeGradient()
        }
    }
    
    @IBInspectable var dropShadow:Bool = false {
        didSet {
            initUI()
        }
    }
    @IBInspectable var shadowSize:CGFloat = 11
    @IBInspectable var shadowOffsetX:CGFloat = 5
    @IBInspectable var shadowOffsetY:CGFloat = 18
    @IBInspectable var placeHolder:UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            imageView.image
        }
    }
    var range:CGFloat = 1.9
    var btn_inset_top:CGFloat {
        shadowSize * range - shadowOffsetY
    }
    
    var btn_inset_left:CGFloat {
        shadowSize * range - shadowOffsetX
    }
    var btn_inset_bottom:CGFloat {
        shadowSize * range  + shadowOffsetY
    }
    var btn_inset_right:CGFloat {
        shadowSize * range + shadowOffsetX
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    public let imageView = UIImageView()
    let shadowView = UIView()
    let dimView = UIView()
    weak var gl:CAGradientLayer? = nil
    
    var inset:UIEdgeInsets {
        if dropShadow {
            return UIEdgeInsets(top: btn_inset_top, left: btn_inset_left , bottom: btn_inset_bottom, right: btn_inset_right)
        }
        return .zero
    }
    
    public func setImage(with: Resource?) {
        imageView.kf.setImage(with: with, placeholder: placeHolder)
    }
    
    func initUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        for view in [imageView, shadowView, dimView] {
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        addSubview(shadowView)
        addSubview(imageView)
        addSubview(dimView)
        dimView.backgroundColor = dimColor
      
        backgroundColor = .clear
        let gesture = UITapGestureRecognizer( target: self, action: #selector(self.onTap(gesture:)))
        addGestureRecognizer(gesture)
        shadowView.alpha = 0
        fixImageViewFrame()

    }
    
    @IBInspectable var touchSelectEnable:Bool = true
    
    @objc func onTap(gesture:UITapGestureRecognizer) {
        isSelected.toggle()
    }
    
    
    func makeGradient() {
        if gradientOvery {
            gl?.removeFromSuperlayer()
            let gl = CAGradientLayer()
            gl.colors = [UIColor(white: 0, alpha: 0 ).cgColor,UIColor(white: 0, alpha: 0.3).cgColor]
            gl.locations = [0.5, 1.0]
            gl.startPoint = CGPoint(x:0,y:0)
            gl.endPoint = CGPoint(x:0,y:1.0)
            gl.frame = CGRect(x: 0, y: 0, width: dimView.frame.width, height: dimView.frame.height)
            dimView.layer.insertSublayer(gl, at: 0)
            self.gl = gl
        } else {
            gl?.removeFromSuperlayer()
        }
    }
    
    func makeDropShadow() {
        if dropShadow {
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
            shadowView.layer.shadowRadius = shadowSize
            shadowView.layer.shadowOpacity = 0.35
            shadowView.backgroundColor = .black
            shadowView.layer.cornerRadius = 2
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = 2
            dimView.layer.cornerRadius = 2
            dimView.layer.borderWidth = 3
            dimView.layer.borderColor = UIColor.white.cgColor
            
            shadowView.isHidden = false
            UIView.animate(withDuration: 0.5) {[weak self]in
                let isSelected = self?.isSelected ?? false
                self?.shadowView.alpha = isSelected ? 1 : 0
            }
        }
        else {
            shadowView.isHidden = true
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        fixImageViewFrame()
        makeGradient()
        makeDropShadow()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        fixImageViewFrame()
        makeGradient()
        makeDropShadow()
    }
    
    func fixImageViewFrame() {
        imageView.frame = CGRect(x: inset.left, y: inset.top, width: bounds.width - inset.left - inset.right, height: bounds.height - inset.top - inset.bottom)
        dimView.frame = imageView.frame
        shadowView.frame = CGRect(x: imageView.frame.origin.x + 2, y: imageView.frame.origin.y + 2, width: imageView.frame.width - 4, height: imageView.frame.height - 4)
    }
    
}
