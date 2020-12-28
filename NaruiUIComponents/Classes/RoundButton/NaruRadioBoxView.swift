//
//  NaruRadioBoxView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/16.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
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
    
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    @IBInspectable var idx:Int = 0
    @IBInspectable var title:String = "" {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    @IBInspectable var noColor:UIColor = .white
    @IBInspectable var seColor:UIColor = .white
    
    @IBInspectable var noTitleColor:UIColor? = nil {
        didSet {
            button.setTitleColor(noTitleColor ?? noColor, for: .normal)
        }
    }
    @IBInspectable var seTitleColor:UIColor? = nil{
        didSet {
            button.setTitleColor(seTitleColor ?? seColor, for: .selected)
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
        alpha = isEnable ? 1 : 0.5
        
        var color:UIColor {
            if isEnable == false {
                return noColor
            }
            return button.isSelected ? seColor : noColor
        }
        button.tintColor = color
        layer.borderColor = color.cgColor
        layer.cornerRadius = 2
        layer.borderWidth = 1
    }
    

}
