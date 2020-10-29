//
//  NaruTextField.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/28.
//

import UIKit
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
    @IBInspectable var padding:CGFloat = 10.0
    @IBInspectable var isBoxStyle:Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.fixLayout()
            }
        }
    }
    
    @IBInspectable var lineColor:UIColor? {
        set {
            lineView.backgroundColor = newValue
        }
        get {
            lineView.backgroundColor
        }
    }
    
    @IBInspectable var boxlineColor:UIColor = .white
    @IBInspectable var textColor:UIColor? {
        set {
            textField.textColor = newValue
        }
        get {
            textField.textColor
        }
    }
    
    @IBInspectable var returnKeyType:Int {
        set {
            textField.returnKeyType = UIReturnKeyType(rawValue: newValue) ?? .default
        }
        get {
            textField.returnKeyType.rawValue
        }
    }
    
    @IBInspectable var textContentType:String {
        set {
            textField.textContentType = UITextContentType(rawValue: newValue)
        }
        get {
            textField.textContentType.rawValue
        }
    }
    
    @IBInspectable var keyboardType:Int {
        set {
            textField.keyboardType = UIKeyboardType(rawValue: newValue) ?? .default
        }
        get {
            textField.keyboardType.rawValue
        }
    }
    
    @IBInspectable var placeHolder:String? {
        set {
            textField.placeholder = newValue
            titleLabel.text = newValue
        }
        get {
            textField.placeholder
        }
    }
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
        textField.addTarget(self, action: #selector(onChangeTextField(_:)), for: .editingChanged)
        lineView.alpha = 0.5
        lineView.backgroundColor = lineColor
        textField.delegate = self
        fixLayout()
        returnCallBack = { [weak self] _ in
            _ = self?.resignFirstResponder()
        }
    }

    //MARK:-
    @objc func onTap(_ gesture:UITapGestureRecognizer) {
        if textField.isFocused == false {
            textField.becomeFirstResponder()
        }
    }
    
    @objc func onChangeTextField(_ sender:UITextField) {
        fixLayout()
    }
    
    private func fixLayout() {
        if isBoxStyle {
            lineView.isHidden = true
            layer.borderWidth = 1.0
            layer.borderColor = lineColor?.cgColor ?? UIColor.black.cgColor
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
    }
    
    private func focus(isOn:Bool) {
        guard let lineColor = lineColor else {
            return
        }
        UIView.animate(withDuration: 0.25) {[unowned self] in
            lineView.alpha = isOn ? 1 : 0.5
            if isBoxStyle {
                layer.borderColor = isOn ? lineColor.cgColor : boxlineColor.cgColor
            }
        }
    }
    
    //MARK:-
    //MARK:set rightButton
    private var rightButtonCallBack:()->Void = {}
    public func setRightButton(title:String, font:UIFont = UIFont.systemFont(ofSize: 10), normalColor:UIColor? = nil, highlightedColor:UIColor? = nil, mode:UITextField.ViewMode = .unlessEditing, callBack:@escaping()->Void) {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(self.onTouchupRightButton(_:)), for: .touchUpInside)
        btn.setTitleColor(normalColor ?? textField.textColor, for: .normal)
        btn.setTitleColor(highlightedColor ?? textField.textColor, for: .highlighted)
        
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
