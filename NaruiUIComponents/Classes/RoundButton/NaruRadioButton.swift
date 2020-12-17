//
//  NaruRadioButton.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/04.
//

import UIKit
import RxSwift
import RxCocoa

extension Notification.Name {
    static let naruRadioButtonSelect = Notification.Name(rawValue: "naruRadioButtonSelect_observer")
}

@IBDesignable
public class NaruRadioButton: UIView {
    @IBInspectable var idx:Int = 0
    @IBInspectable var groupid:String? = nil
    
    public var isEnable:Bool {
        set {
            button.isEnabled = newValue
        }
        get {
            button.isEnabled
        }
    }
    
    public var radioButton:UIButton {
        return button
    }
    
    let disposeBag = DisposeBag()
    //MARK:-
    //MARK:IBInspectable
    @IBInspectable var normalColor:UIColor = .white {
        didSet {
            DispatchQueue.main.async {[unowned self] in
                setTintColor()
            }
        }
    }

    @IBInspectable var selectedColor:UIColor = .gray {
        didSet {
            DispatchQueue.main.async {[unowned self] in
                setTintColor()
            }
        }
    }
    //MARK:-
    //MARK:IBOutlet
    
    @IBOutlet weak var button:UIButton!
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
                nibName: String(describing: NaruRadioButton.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        button.rx.tap.bind { [unowned self](_) in
            button.isSelected = true
            NotificationCenter.default.post(name: .naruRadioButtonSelect, object: idx)
            button.tintColor = button.isSelected ? selectedColor : normalColor
        }.disposed(by: disposeBag)
        
        button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(button.image(for: .selected)?.withRenderingMode(.alwaysTemplate), for: .selected)
        NotificationCenter.default.addObserver(forName: .naruRadioButtonSelect, object: nil, queue: nil) { [weak self](noti) in
            if noti.object as? Int != self?.idx {
                self?.button.isSelected = false
            }
        }
        setTintColor()
    }

    func setTintColor() {
        button.tintColor = button.isSelected ? selectedColor : normalColor
    }
}
