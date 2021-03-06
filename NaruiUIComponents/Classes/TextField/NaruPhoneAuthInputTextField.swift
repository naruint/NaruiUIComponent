//
//  NaruPhoneAuthInputTextField.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/16.
//

import UIKit
import RxCocoa
import RxSwift
import PhoneNumberKit

//@IBDesignable
public class NaruPhoneAuthInputTextField: UIView {
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
                nibName: String(describing: NaruPhoneAuthInputTextField.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textField.isEnabled = false
        textField.delegate = self
        button.isEnabled = false
        updateUI()
    }
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var clearBtnImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button:UIButton!
    @IBOutlet weak var timeCountLabel: UILabel!
    //MARK:-
    //MARK:IBInspectable
    @IBInspectable var isRequired:Bool = false
    @IBInspectable var requiredColor:UIColor = .green
    
    /** normal Btn Color*/
    @IBInspectable var noBtnColor:UIColor = .black {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setBackgroundImage(self?.noBtnColor.image, for: .normal)
            }
        }
    }
    /** selected btn color */
    @IBInspectable var seBtnColor:UIColor = .gray {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setBackgroundImage(self?.seBtnColor.image, for: .selected)
            }
        }
    }
    /** highlighted btn color*/
    @IBInspectable var hiBtnColor:UIColor = .gray {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setBackgroundImage(self?.hiBtnColor.image, for: .highlighted)
            }
        }
    }

    /** disabled btn color*/
    @IBInspectable var diBtnColor:UIColor = .gray {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.button.setBackgroundImage(self?.diBtnColor.image, for: .disabled)
            }
        }
    }
    /** button text color*/
    @IBInspectable var btnTxtColor:UIColor? {
        set {
            DispatchQueue.main.async {[weak self]in
                self?.button.setTitleColor(newValue, for: .normal)
            }
        }
        get {
            button.titleColor(for: .normal)
        }
    }
    
    @IBInspectable var titleForBtn:String? {
        set {
            DispatchQueue.main.async {[weak self]in
                self?.button.setTitle("  \(newValue ?? " ")  ", for: .normal)
            }
        }
        get {
            button.title(for: .normal)
        }
    }
    
    @IBInspectable var title:String? = nil {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.titleLabel.text = self?.title
            }
        }
    }
    
    @IBInspectable var titleColor:UIColor? {
        set {
            DispatchQueue.main.async {[weak self]in
                self?.titleLabel.textColor = newValue
            }
        }
        get {
            titleLabel.textColor
        }
    }
    
    @IBInspectable var textColor:UIColor? {
        set {
            DispatchQueue.main.async {[weak self]in
                self?.textField.textColor = newValue
            }
        }
        get {
            textField.textColor
        }
    }
    
    @IBInspectable var placeHolder:String? = nil
    
    @IBInspectable var placeHolderColor:UIColor = .gray {
        didSet {
            DispatchQueue.main.async {[weak self]in
                if let txt = self?.placeHolder {
                    self?.textField.attributedPlaceholder = NSAttributedString(string: txt, attributes: [.foregroundColor:self?.placeHolderColor ?? .black])
                }
            }
        }
    }

    /** 포커스 상태의 라인 컬러*/
    @IBInspectable var seLineColor:UIColor = .black
    /** 보통상태의 라인 컬러*/
    @IBInspectable var noLineColor:UIColor = .gray
    
    var text:String? {
        get {
            textField.text
        }
    }
    //MARK:-
    public override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    func updateUI() {
        layer.cornerRadius = 2
        borderWidth = 1
        borderColor = isFirstResponder ? seLineColor : noLineColor
        button.isEnabled = isTimeOver == false
        textField.setClearButtonImage(image: clearBtnImageView.image!)
        if isRequired {
            titleLabel.attributedText = title?.makeRequiredAttributeString(textColor: titleColor ?? .black, pointColor: requiredColor, height: titleLabel.font.pointSize)
        }
    }
    
    var touchupButtonCallBack:()->Void = {}
    
    public func setTouchupButton(_ callBack:@escaping()->Void) {
        touchupButtonCallBack = callBack
    }
    
    var time:Date? = nil
    
    public func startCountDown(interval:TimeInterval) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
        let now = Date().timeIntervalSince1970
        let newDate = Date(timeIntervalSince1970: now + interval)
        time = newDate
        updateTimmer()
        isTimeOver = false
    }
    var isTimeOver:Bool = false
    
    func updateTimmer() {
        guard let t = time else {
            return
        }
        let a = t.timeIntervalSince1970
        let b = Date().timeIntervalSince1970
        let interval = Int(a - b)
        if interval == 0 {
            isTimeOver = true
            time = nil
            updateUI()
            timeCountLabel.text = "  0:00  "
            return
        }
        let m = Int(interval / 60)
        let s = interval % 60
        timeCountLabel.text = String(format: "  %d:%02d  ", m,s)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.updateTimmer()
        }
    }
}

extension NaruPhoneAuthInputTextField : UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateUI()
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateUI()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateUI()
        return true
    }
}

