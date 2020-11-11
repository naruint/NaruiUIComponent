//
//  NaruTextField.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/28.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
public class NaruTextField: UIView {
    //MARK:-
    //MARK:IBOUtlet
    @IBOutlet weak var lineView: UIView!
    @IBOutlet public weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    //MARK:-
    //MARK:IBInspectable
    @IBInspectable var padding:CGFloat = 0.0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }
    
    @IBInspectable var isBoxStyle:Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }
    
    @IBInspectable var normalLineColor:UIColor = .white {
        didSet {
            DispatchQueue.main.async {[unowned self]in
                lineView.backgroundColor = normalLineColor
            }
        }
    }
    @IBInspectable var errorLineColor:UIColor = .red
    @IBInspectable var focusLineColor:UIColor = .black
    
    @IBInspectable var textColor:UIColor? {
        set {
            textField.textColor = newValue
        }
        get {
            textField.textColor
        }
    }
    
    @IBInspectable var placeHolder:String? = "" {
        didSet {
            DispatchQueue.main.async {[unowned self]in
                textField.placeholder = placeHolder
                titleLabel.text = placeHolder
            }
        }
    }
    
    /** place Holder Color*/
    @IBInspectable var PH_Color:UIColor = .gray
    /** Place Holder Label Text Color */
    @IBInspectable var PH_labelColor:UIColor? {
        set {
            titleLabel.textColor = newValue
        }
        get {
            titleLabel.textColor
        }
    }
    
    @IBInspectable var isRequired:Bool = false
    @IBInspectable var requiredText:String = "・"
    @IBInspectable var requiredColor:UIColor = UIColor.green
    
    
    
    public var isError:Bool = false {
        didSet {
            DispatchQueue.main.async {[unowned self] in
                lineView.backgroundColor = isError ? errorLineColor : normalLineColor
                updateUI()
            }
        }
    }
    
    func setAttributedPlaceHolder() {
        func attr(color:UIColor,fontSize:CGFloat)->NSAttributedString {
            let str = NSMutableAttributedString()
            str.append(NSAttributedString(string: placeHolder ?? "" ,
                                          attributes:[
                                            .foregroundColor : color,
                                            .font:UIFont.systemFont(ofSize: fontSize)
                                          ]))
            if isRequired {
                str.append(NSAttributedString(string: " "))
                str.append(NSAttributedString(string: requiredText,
                                              attributes: [
                                                .foregroundColor : requiredColor,
                                                .font : UIFont.systemFont(ofSize: fontSize + 10)
                                              ]))
            }
            return str
        }
        DispatchQueue.main.async {[unowned self] in
            textField.attributedPlaceholder = attr(color: PH_Color, fontSize: textField.font?.pointSize ?? 10)
            titleLabel.attributedText = attr(color: PH_labelColor ?? PH_Color , fontSize: titleLabel.font.pointSize)
        }
    }
    
    //MARK:-
    let disposeBag = DisposeBag()
    //MARK:-
    //MARK:arrangeView
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
                nibName: String(describing: NaruTextField.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        addGestureRecognizer(gesture)
        lineView.alpha = 0.5
        lineView.backgroundColor = normalLineColor
        textField.delegate = self
        updateUI()
        returnCallBack = { [weak self] _ in
            _ = self?.resignFirstResponder()
        }
        textField.rx.text.orEmpty.bind { [unowned self](string) in
            updateUI()
            let isEmpty = textField.text == nil || textField.text?.isEmpty == true
            if rightViewMode == .unlessEditing && isHideRightViewWhenInput {
                textField.rightViewMode = isEmpty ? .unlessEditing : .never
            }
        }.disposed(by: disposeBag)
        
    }

    //MARK:-
    @objc func onTap(_ gesture:UITapGestureRecognizer) {
        if textField.isFocused == false {
            textField.becomeFirstResponder()
        }
    }
        
    private func updateUI() {
        if isBoxStyle {
            lineView.isHidden = true
            layer.borderWidth = 1.0
            layer.borderColor = isError ? errorLineColor.cgColor : normalLineColor.cgColor
            
        }
        
        let isHidden = textField.text?.isEmpty ?? true
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {[unowned self] in
            titleLabel.alpha = isHidden ? 0 : 1
        } completion: { (fin) in
            
        }
        for layout in [leading, trailing] {
            layout?.constant = padding
        }
        focus(isOn: textField.isFirstResponder)
        setAttributedPlaceHolder()
    }
    
    private func focus(isOn:Bool) {
        UIView.animate(withDuration: 0.25) {[unowned self] in
            lineView.alpha = isOn ? 1 : 0.5
            if isBoxStyle {
                if isError {
                    layer.borderColor = errorLineColor.cgColor
                } else {
                    layer.borderColor = isOn ? focusLineColor.cgColor : normalLineColor.cgColor
                }
            }
        }
    }
    
    //MARK:-
    //MARK:set rightButton
    /** 텍스트필드 문자를 입력할 경우 rightView 감추기 에 대한 flag*/
    private var isHideRightViewWhenInput:Bool = false
    /** 오른쪽 버튼 눌렀을 때 콜백 저장*/
    private var rightButtonCallBack:()->Void = {}
    /** rightViewMode  저장*/
    private var rightViewMode:UITextField.ViewMode = .never
    /** 오른쪽 버튼 추가하기.*/
    public func setRightButton(title:String,
                               font:UIFont = UIFont.systemFont(ofSize: 10),
                               normalColor:UIColor? = nil,
                               highlightedColor:UIColor? = nil,
                               mode:UITextField.ViewMode = .unlessEditing,
                               isHideRightViewWhenInput:Bool = false,
                               callBack:@escaping()->Void) {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(self.onTouchupRightButton(_:)), for: .touchUpInside)
        btn.setTitleColor(normalColor ?? textField.textColor, for: .normal)
        btn.setTitleColor(highlightedColor ?? textField.textColor, for: .highlighted)
        self.isHideRightViewWhenInput = isHideRightViewWhenInput
        rightViewMode = mode
        textField.rightView = btn
        textField.rightViewMode = mode
        rightButtonCallBack = callBack
        
    }
    
    @objc func onTouchupRightButton(_ sender:UIButton) {
        rightButtonCallBack()
    }
    
    private var returnCallBack:(_ textField:UITextField)->Void = {_ in }
    public func setReturn(callback:@escaping(_ textField:UITextField)->Void) {
        returnCallBack = callback
    }
    
    //MARK:-
    //MARK:Focus Method override
    public override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    public var returnKeyType:UIReturnKeyType {
        set {
            textField.returnKeyType = newValue
        }
        get {
            textField.returnKeyType
        }
    }
    
    public var textContentType:UITextContentType {
        set {
            textField.textContentType = newValue
        }
        get {
            textField.textContentType
        }
    }
    
    public var keyboardType:UIKeyboardType {
        set {
            textField.keyboardType = newValue
        }
        get {
            textField.keyboardType
        }
    }
    
    public override var inputView: UIView? {
        set {
            textField.inputView = newValue
        }
        get {
            textField.inputView
        }
    }

    /** 비밀번호 보기 전환하기 버튼*/
    var switchShowPWDButton:UIButton? = nil
    
    /** 비밀번호 보기 뷰가 있는 비밀번호 입력 뷰로 만들기*/
    public var isSecureMode:Bool = false {
        didSet {
            if isSecureMode {
                setPwdMode()
            }
        }
    }
    
    func setPwdMode() {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "passwordViewIconSelected").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "passwordViewIconSelected").withRenderingMode(.alwaysTemplate), for: .selected)
        btn.isSelected = true
        textField.isSecureTextEntry = true
        textField.keyboardType = .asciiCapable
        btn.tintColor = normalLineColor
        btn.rx.tap.bind { [unowned self](_) in
            btn.isSelected.toggle()
            btn.tintColor = btn.isSelected ? normalLineColor : focusLineColor
            textField.isSecureTextEntry = btn.isSelected
        }.disposed(by: disposeBag)
        switchShowPWDButton = btn
        textField.rightViewMode = .always
        textField.rightView = btn
        textField.clearButtonMode = .always
    }
     
}
//MARK:-
//MARK:UITextFieldDelegate
extension NaruTextField : UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        focus(isOn: true)
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        focus(isOn: false)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnCallBack(textField)
        return true
    }
}
