//
//  NaruTextField.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/28.
//

import UIKit
import RxSwift
import RxCocoa

//@IBDesignable
public class NaruTextField: UIView {
    //MARK:-
    //MARK:IBOUtlet
    @IBOutlet weak var lineView: UIView!
    @IBOutlet public weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var showPwdButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var topPaddingView: UIView!
    @IBOutlet weak var bottomPaddingView: UIView!
    
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
            DispatchQueue.main.async {[weak self]in
                self?.lineView.backgroundColor = self?.normalLineColor
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
            DispatchQueue.main.async {[weak self]in
                self?.textField.placeholder = self?.placeHolder
                self?.titleLabel.text = self?.placeHolder
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
    @IBInspectable var requiredColor:UIColor = UIColor.green
    
    
    
    public var isError:Bool = false {
        didSet {
            DispatchQueue.main.async {[weak self] in
                guard let s = self else {
                    return
                }
                s.lineView.backgroundColor = s.isError ? s.errorLineColor : s.normalLineColor
                s.updateUI()
            }
        }
    }
    
    func setAttributedPlaceHolder() {
        DispatchQueue.main.async {[weak self] in
            guard let s = self else {
                return
            }
            s.textField.attributedPlaceholder = NSAttributedString(string: s.placeHolder ?? "", attributes: [.foregroundColor : s.PH_Color])
            if s.isRequired {
                s.textField.attributedPlaceholder = s.placeHolder?.makeRequiredAttributeString(
                    textColor: s.PH_labelColor ?? s.PH_Color ,
                    pointColor: s.requiredColor,
                    height: s.textField.font?.pointSize ?? 10)
                s.titleLabel.attributedText = s.placeHolder?.makeRequiredAttributeString(
                    textColor: s.PH_labelColor ?? s.PH_Color,
                    pointColor: s.requiredColor,
                    height: s.titleLabel.font?.pointSize ?? 10)
            }
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
        lineView.alpha = 1.0
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
            textDidChangeCallBack(string)
        }.disposed(by: disposeBag)
        
    }

    //MARK:-
    @objc func onTap(_ gesture:UITapGestureRecognizer) {
        if textField.isFocused == false {
            textField.becomeFirstResponder()
        }
    }
        
    private func updateUI() {
        changeDeleteBtn()
        if isBoxStyle {
            lineView.isHidden = true
            layer.cornerRadius = 2
            layer.borderWidth = 1.0
            layer.borderColor = isError ? errorLineColor.cgColor : normalLineColor.cgColor
            
        }
        else {
            lineView.isHidden = false
            lineView.backgroundColor = isError ? errorLineColor : normalLineColor
        }
        
        let isHidden = textField.text?.isEmpty ?? true
        titleLabel.isHidden = isHidden || titleLabel.text?.isEmpty == true
        topPaddingView.isHidden = titleLabel.isHidden
        bottomPaddingView.isHidden = titleLabel.isHidden
        
        for layout in [leading, trailing] {
            layout?.constant = padding
        }
        focus(isOn: textField.isFirstResponder)
        setAttributedPlaceHolder()
        
    }
    
    private func focus(isOn:Bool) {
        lineView.backgroundColor = isOn ? focusLineColor : normalLineColor
        if isError {
            lineView.backgroundColor = errorLineColor
        }
        if isBoxStyle {
            if isError {
                layer.borderColor = errorLineColor.cgColor
            } else {
                layer.borderColor = isOn ? focusLineColor.cgColor : normalLineColor.cgColor
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
        btn.titleLabel?.font = font
        btn.setTitleColor(normalColor ?? textField.textColor, for: .normal)
        btn.setTitleColor(highlightedColor ?? textField.textColor, for: .highlighted)
        self.isHideRightViewWhenInput = isHideRightViewWhenInput
        rightViewMode = mode
        textField.rightView = btn
        textField.rightViewMode = mode
        rightButtonCallBack = callBack
        changeDeleteBtn()
    }
    
    @objc func onTouchupRightButton(_ sender:UIButton) {
        rightButtonCallBack()
    }
    
    private var returnCallBack:(_ textField:UITextField)->Void = {_ in }
    public func setReturn(callback:@escaping(_ textField:UITextField)->Void) {
        returnCallBack = callback
    }
    
    private var textDidChangeCallBack:(_ text:String)->Void = {_ in}
    public func setTextDidChange(callback:@escaping(_ text:String)->Void) {
        textDidChangeCallBack = callback
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

    
    /** 비밀번호 보기 뷰가 있는 비밀번호 입력 뷰로 만들기*/
    public var isSecureMode:Bool = false {
        didSet {
            if isSecureMode {
                setPwdMode()
            }
        }
    }
    
    public var text:String? {
        set {
            textField.text = newValue
        }
        get {
            textField.text
        }
    }
    
    private func changeDeleteBtn() {
        textField.setClearButtonImage(image: deleteButton.image(for: .normal)!)
    }
    
    func setPwdMode() {
        guard let image1 = showPwdButton.image(for: .normal),
              let image2 = showPwdButton.image(for: .selected) else {
            return
        }
                
        let button = UIButton()
        
        button.setImage(image1.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(image2.withRenderingMode(.alwaysTemplate), for: .selected)
        button.isSelected = true
        textField.isSecureTextEntry = true
        textField.keyboardType = .asciiCapable
        button.tintColor = normalLineColor
        button.rx.tap.bind { [unowned self](_) in
            button.isSelected.toggle()
            button.tintColor = button.isSelected ? normalLineColor : focusLineColor
            textField.isSecureTextEntry = button.isSelected
        }.disposed(by: disposeBag)
        button.frame.size = CGSize(width: 40, height: 25)
        textField.rightViewMode = .always
        textField.rightView = button
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
