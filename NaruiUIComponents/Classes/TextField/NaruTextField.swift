//
//  NaruTextField.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/28.
//

import UIKit
@IBDesignable
public class NaruTextField: UIView {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet public weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    @IBInspectable var padding:CGFloat = 10.0
    @IBInspectable var isBoxStyle:Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.fixLayout()
            }
        }
    }
    
    @IBInspectable var lineColor:UIColor = .white
    @IBInspectable var boxlineColor:UIColor = .white
    
    @IBInspectable var textColor:UIColor = .black
    
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
    }

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
            layer.borderColor = lineColor.cgColor
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
        UIView.animate(withDuration: 0.25) {[unowned self] in
            lineView.alpha = isOn ? 1 : 0.5
            if isBoxStyle {
                layer.borderColor = isOn ? lineColor.cgColor : boxlineColor.cgColor
            }
        }
    }
}

extension NaruTextField : UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        focus(isOn: true)
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        focus(isOn: false)
    }
}
