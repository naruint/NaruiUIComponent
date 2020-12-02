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
    var selectedCallBack:(_ isSelected:Bool)->Void = { _ in }
    
    public var isEnabled:Bool = true {
        didSet {
            if oldValue != isEnabled {
                alpha = isEnabled ? 1 : 0.5
            }
        }
    }
    
    /** 선택 바뀜 콜백*/
    public func onSelectedChange(callback:@escaping(_ isSelected:Bool)->Void) {
        selectedCallBack = callback
    }
        
    public var isSelected:Bool = false {
        didSet {
            makeDropShadow()
            if oldValue != isSelected && isEnabled {
                selectedCallBack(isSelected)
            }
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
    @IBInspectable var shadowColor:UIColor = UIColor.black
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
        shadowSize * range + shadowOffsetX
    }
    var btn_inset_bottom:CGFloat {
        shadowSize * range + shadowOffsetY
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
    
    public enum BottomDecoStyle {
        case play
        case mix
        case none
    }
    
    public var bottomDecoStyle: BottomDecoStyle = .none {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.fixImageViewFrame()
            }
        }
    }
    
    public let imageView = UIImageView()
    let shadowView = UIView()
    let dimView = UIView()
    let gl = CAGradientLayer()
    
    let bottomDecoImageView = UIImageView()
    
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
        dimView.layer.masksToBounds = true

        for view in [imageView, shadowView, dimView] {
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        addSubview(shadowView)
        addSubview(imageView)
        addSubview(dimView)
        addSubview(bottomDecoImageView)
        dimView.backgroundColor = dimColor
      
        backgroundColor = .clear
        shadowView.alpha = 0
        fixImageViewFrame()

        bottomDecoImageView.translatesAutoresizingMaskIntoConstraints = false
       
        bottomDecoImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        bottomDecoImageView.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -2).isActive = true
        bottomDecoImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        bottomDecoImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        bottomDecoImageView.layer.cornerRadius = 12
        bottomDecoImageView.backgroundColor = .white
        bottomDecoImageView.contentMode = .center
        bottomDecoImageView.layer.shadowColor = shadowColor.cgColor
        bottomDecoImageView.layer.shadowRadius = 5
        bottomDecoImageView.layer.shadowOpacity = 0.15
    }

    weak var tapGesture:UITapGestureRecognizer? = nil

    @IBInspectable var touchSelectEnable:Bool = false {
        didSet {
            if touchSelectEnable {
                let gesture = UITapGestureRecognizer( target: self, action: #selector(self.onTap(gesture:)))
                self.tapGesture = gesture
                addGestureRecognizer(gesture)
            }
            else if let g = tapGesture {
                removeGestureRecognizer(g)                
            }
        }
    }
    
    @objc func onTap(gesture:UITapGestureRecognizer) {
        if touchSelectEnable {
            isSelected.toggle()
        }
    }
    
    
    func makeGradient() {
        if gradientOvery {
            gl.colors = [UIColor(white: 0, alpha: 0 ).cgColor,UIColor(white: 0, alpha: 0.3).cgColor]
            gl.locations = [0.5, 1.0]
            gl.startPoint = CGPoint(x:0,y:0)
            gl.endPoint = CGPoint(x:0,y:1.0)
            gl.frame = CGRect(x: 0, y: 0, width: dimView.frame.width, height: dimView.frame.height)
            dimView.layer.insertSublayer(gl, at: 0)
        } else {
            gl.removeFromSuperlayer()
        }
    }
    
    func makeDropShadow() {
        if dropShadow {
            shadowView.layer.shadowColor = shadowColor.cgColor
            shadowView.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
            shadowView.layer.shadowRadius = shadowSize
            shadowView.layer.shadowOpacity = 0.35
            shadowView.backgroundColor = .black
            shadowView.layer.cornerRadius = 2
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
            imageView.layer.cornerRadius = 2
            dimView.layer.cornerRadius = 2
            dimView.layer.borderWidth = 3
            dimView.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
            
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
        
        switch bottomDecoStyle {
        case .none:
            bottomDecoImageView.isHidden = true
        case .mix:
            bottomDecoImageView.isHidden = false
            bottomDecoImageView.image = UIImage(named: "icon16Mix",in: Bundle(for: NaruImageView.self), compatibleWith: nil)
            
        case .play:
            bottomDecoImageView.isHidden = false
            bottomDecoImageView.image = UIImage(named: "icon16Sound",in: Bundle(for: NaruImageView.self), compatibleWith: nil)
        }
    }
    
}
