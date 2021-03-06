//
//  NaruRadioBoxView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/16.
//

import UIKit
import RxSwift
import RxCocoa

//@IBDesignable
public class NaruRadioBoxView: UIView {

    public var radioButton:UIButton {
        return button
    }
    
    public var isEnable:Bool {
        set {
            radioButton.isEnabled = newValue
        }
        get {
            radioButton.isEnabled
        }
    }
    
    public var isSelected:Bool {
        set {
            radioButton.isSelected = newValue
            updateUI()
        }
        get {
            radioButton.isSelected
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    @IBInspectable var idx:Int = 0
    @IBInspectable var title:String = "" {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setTitle(self?.title, for: .normal)
            }
        }
    }
    /** normal Line Color*/
    @IBInspectable var noColor:UIColor = .white
    /** selected Line tColor*/
    @IBInspectable var seColor:UIColor = .white
    /** disabled line color*/
    @IBInspectable var diColor:UIColor = .gray
    

    /** normal title color*/
    @IBInspectable var noTitleColor:UIColor? = nil {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setTitleColor(self?.noTitleColor ?? self?.noColor, for: .normal)
            }
        }
    }
    /** selected title color*/
    @IBInspectable var seTitleColor:UIColor? = nil{
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setTitleColor(self?.seTitleColor ?? self?.seColor, for: .selected)
            }
        }
    }
    /** disabled text color */
    @IBInspectable var diTitleColor:UIColor? = nil {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setTitleColor(self?.diTitleColor, for: .disabled)
            }
        }
    }
    
    @IBInspectable var noBgColor: UIColor = .white {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setBackgroundImage(self?.noBgColor.image, for: .normal)
            }
        }
    }
    @IBInspectable var seBgColor: UIColor = .white {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setBackgroundImage(self?.seBgColor.image, for: .selected)
            }
        }
    }
    @IBInspectable var diBgColor: UIColor = .gray {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setBackgroundImage(self?.diBgColor.image, for: .disabled)
            }
        }
    }

    
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
                nibName: String(describing: NaruRadioBoxView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       
        button.rx.tap.bind { [unowned self](_) in
            button.isSelected = true
            NotificationCenter.default.post(name: .naruRadioButtonSelect, object: self.idx, userInfo: nil)
            updateUI()
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(forName: .naruRadioButtonSelect, object: nil, queue: nil) { [weak self](noti) in
            if noti.object as? Int != self?.idx {
                self?.button.isSelected = false
                self?.updateUI()
            }
        }
        updateUI()
    }
    
    public override func didMoveToWindow() {
        updateUI()
    }

    @IBAction func ohTouchUPButton(_ sender: UIButton) {
        button.isSelected = true
        NotificationCenter.default.post(name: .naruRadioButtonSelect, object: self.idx, userInfo: nil)
        updateUI()
    }
    
    func updateUI() {
        var color:UIColor {
            if isEnable == false {
                return diColor
            }
            return button.isSelected ? seColor : noColor
        }
        
        button.tintColor = color
        layer.borderColor = color.cgColor
        
        layer.cornerRadius = 2
        layer.borderWidth = 1
    }
    

}
