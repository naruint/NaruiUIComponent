//
//  NaruPhoneNumberTextField.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/16.
//

import UIKit
import RxCocoa
import RxSwift
import PhoneNumberKit

@IBDesignable
public class NaruPhoneNumberTextField: UIView {
    public struct Result {
        public let carrier:String
        public let national:String
        public let e164:String
    }
    
    /** 통신사 목록*/
    let carriers:[String] = [
        "SKT","KT","LG U+", "SKT 알뜰폰", "KT 알뜰폰", "LG U+ 알뜰폰"
    ]
    let carriersPicker = UIPickerView()
    
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
                nibName: String(describing: NaruPhoneNumberTextField.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        firstTextField.rightView = downButton
        firstTextField.rightViewMode = .always
        for tf in [firstTextField, secondTextField] {
            tf?.delegate = self
        }
        updateUI()
        firstTextField.inputView = carriersPicker
        carriersPicker.dataSource = self
        carriersPicker.delegate = self
        firstTextField.text = carriers.first
        
        button.isEnabled = false
        secondTextField.rx.text.orEmpty.bind {[unowned self] (string) in
            button.isEnabled = false
            if let number = try? phoneNumberKit.parse(string) {
                let newStr = phoneNumberKit.format(number, toType: .national)
                print(newStr)
                secondTextField.text = newStr
                button.isEnabled = true
            }
        }.disposed(by: disposeBag)
        
        button.rx.tap.bind { [unowned self](_) in
            guard let carrier = firstTextField.text,
                  let phoneNumber = secondTextField.text,
                  let number = try? phoneNumberKit.parse(phoneNumber)
            else {
                return
            }
            
            let e164 = phoneNumberKit.format(number, toType: .e164)
           
            let result = Result(carrier: carrier, national: phoneNumber, e164: e164)
            touchupButtonCallBack(result)
        }.disposed(by: disposeBag)
        let titleLabel = UILabel()
        titleLabel.text = "통신사 선택"
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.autoresizingMask = [.flexibleWidth]
        titleLabel.frame.size.width = carriersPicker.frame.width
        carriersPicker.addSubview(titleLabel)
    }
    
    let phoneNumberKit = PhoneNumberKit()
    let disposeBag = DisposeBag()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var button:UIButton!
    @IBOutlet weak var clearImageView: UIImageView!
    @IBOutlet weak var carrierTfWidth: NSLayoutConstraint!
    //MARK:-
    //MARK:IBInspectable
    @IBInspectable var isRequired:Bool = false
    @IBInspectable var requiredStrig:String = "・"
    @IBInspectable var requiredColor:UIColor = .green
    
    /** normal Btn Color*/
    @IBInspectable var noBtnColor:UIColor = .black {
        didSet {
            button.setBackgroundImage(noBtnColor.image, for: .normal)
        }
    }
    /** selected btn color */
    @IBInspectable var seBtnColor:UIColor = .gray {
        didSet {
            button.setBackgroundImage(seBtnColor.image, for: .selected)
        }
    }
    /** highlighted btn color*/
    @IBInspectable var hiBtnColor:UIColor = .gray {
        didSet {
            button.setBackgroundImage(hiBtnColor.image, for: .highlighted)
        }
    }

    /** disabled btn color*/
    @IBInspectable var diBtnColor:UIColor = .gray {
        didSet {
            button.setBackgroundImage(diBtnColor.image, for: .disabled)
        }
    }
    /** button text color*/
    @IBInspectable var btnTxtColor:UIColor? {
        set {
            button.setTitleColor(newValue, for: .normal)
            button.setTitleColor(newValue, for: .selected)
            button.setTitleColor(newValue, for: .disabled)
        }
        get {
            button.titleColor(for: .normal)
        }
    }
    
    @IBInspectable var titleForBtn:String? {
        set {
            button.setTitle("  \(newValue ?? " ")  ", for: .normal)
        }
        get {
            button.title(for: .normal)
        }
    }
    
    @IBInspectable var title:String? {
        set {
            titleLabel.text = newValue
        }
        get {
            titleLabel.text
        }
    }
    /** 타이틀 라벨 의 텍스트 컬러*/
    @IBInspectable var titleColor:UIColor? {
        set {
            titleLabel.textColor = newValue
        }
        get {
            titleLabel.textColor
        }
    }
    /** 텍스트 필드의 텍스트 컬러*/
    @IBInspectable var textColor:UIColor? {
        set {
            for tf in [firstTextField, secondTextField] {
                tf?.textColor = newValue
            }
            firstTextField.rightView?.tintColor = newValue
        }
        get {
            firstTextField.textColor
        }
    }
    @IBInspectable var placeHolder:String? = nil {
        didSet {
            secondTextField.placeholder = placeHolder
        }
    }
    
    @IBInspectable var placeHolderColor:UIColor = .gray {
        didSet {
            if let txt = placeHolder {
                secondTextField.attributedPlaceholder = NSAttributedString(string: txt, attributes: [.foregroundColor:placeHolderColor])
            }
        }
    }
    
    /** 포커스 상태의 라인 컬러*/
    @IBInspectable var foLineColor:UIColor = .black
    /** 보통상태의 라인 컬러*/
    @IBInspectable var noLineColor:UIColor = .gray
    
    //MARK:-
    
    public override var isFirstResponder: Bool {
        return firstTextField.isFirstResponder || secondTextField.isFirstResponder
    }
    
    func updateUI() {
        layer.cornerRadius = 2
        borderWidth = 1
        borderColor = isFirstResponder ? foLineColor : noLineColor
        secondTextField.setClearButtonImage(image: clearImageView.image!)
        if isRequired {
            titleLabel.attributedText = titleLabel.text?.makeRequiredAttributeString(requiredString: requiredStrig, color: requiredColor, fontSize: titleLabel.font.pointSize)
        }
    }
    
    var touchupButtonCallBack:(_ result:Result)->Void = { _ in
    }
    
    public func setTouchupButton(_ callBack:@escaping(_ result:Result)->Void) {
        touchupButtonCallBack = callBack
    }
    
}

extension NaruPhoneNumberTextField : UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateUI()
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateUI()
    }
}


extension NaruPhoneNumberTextField : UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return carriers.count
    }
}

extension NaruPhoneNumberTextField : UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return carriers[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        firstTextField.text = carriers[row]
        firstTextField.endEditing(true)
        carrierTfWidth.constant = firstTextField.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: firstTextField.frame.height)).width
        
        
    }
}
