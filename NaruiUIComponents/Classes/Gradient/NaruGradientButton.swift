//
//  NaruGradientButton.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/12.
//

import UIKit

@IBDesignable
public class NaruGradientButton: UIView {
    public var isEnabled:Bool {
        set {
            button.isEnabled = newValue
            gradientLayer?.isHidden = !isEnabled
        }
        get {
            button.isEnabled
        }
    }
    
    @IBInspectable var buttonEnabled:Bool {
        set {
            isEnabled = newValue
        }
        get {
            isEnabled
        }
    }
    
    @IBInspectable var titleText:String? {
        set {
            button.setTitle(newValue, for: .normal)
        }
        get {
            button.title(for: .normal)
        }
    }
    @IBInspectable var normalTextColor:UIColor? {
        set {
            button.setTitleColor(newValue, for: .normal)
        }
        get {
            button.titleColor(for: .normal)
        }
    }
    @IBInspectable var selectedTextColor:UIColor? {
        set {
            button.setTitleColor(newValue, for: .selected)
            button.setTitleColor(newValue, for: .highlighted)
        }
        get {
            button.titleColor(for: .selected)
        }
    }
    @IBInspectable var disabledTextColor:UIColor? {
        set {
            button.setTitleColor(newValue, for: .disabled)
        }
        get {
            button.titleColor(for: .disabled)
        }
    }
    @IBInspectable var disabledBGColor:UIColor = .gray {
        didSet {
            button.setBackgroundImage(disabledBGColor.image, for: .disabled)
        }
    }
    
    
    private var colors:[CGColor] = [
        UIColor(red: 252/255, green: 241/255, blue: 80/255, alpha: 1).cgColor,
        UIColor(red: 255/255, green: 152/255, blue: 55/255, alpha: 1).cgColor,
        UIColor(red: 255/255, green: 54/255, blue: 54/255, alpha: 1).cgColor,
        UIColor(red: 111/255, green: 66/255, blue: 234/255, alpha: 1).cgColor,
        UIColor(red: 111/255, green: 210/255, blue: 250/255, alpha: 1).cgColor,
    ]
    
    @IBOutlet weak var button: UIButton!
    //MARK:-
    //MARK: arrangeView
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        arrangeView()
    }
    
    func arrangeView() {
        guard let view = UINib(
                nibName: String(describing: NaruGradientButton.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        button.addTarget(self, action: #selector(self.onTouchDown(_:)), for: .touchDown)
        for event in [
            UIControl.Event.touchUpInside,
            UIControl.Event.touchUpOutside,
            UIControl.Event.touchCancel
        ] {
            button.addTarget(self, action: #selector(self.onTouchUP(_:)), for: event)
        }
        
    }
    
    var gradientLayer:CAGradientLayer? = nil

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.0, y: 0.49)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.51)
        gradient.locations = [0.0,0.2,0.4,0.7,1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: button.frame.size.width, height: button.frame.size.height)
        // print(gradient.frame)
        button.layer.insertSublayer(gradient, at: 0)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        gradientLayer = gradient
    }
    
    @objc func onTouchDown(_ sender:UIButton) {
        gradientLayer?.opacity = 0.5
    }
    
    @objc func onTouchUP(_ sender:UIButton) {
        gradientLayer?.opacity = 1
    }
    
}
