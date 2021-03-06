//
//  NaruPeopleNumberInputView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/16.
//

import UIKit
import RxSwift
import RxCocoa

/** 주민번호 입력*/
//@IBDesignable
public class NaruPeopleNumberInputView: UIView {

    @IBInspectable var isRequired:Bool = false
    @IBInspectable var requiredColor:UIColor = .green
    
    @IBInspectable var title:String = ""
    
    @IBInspectable var titleColor:UIColor = .black
    
    @IBInspectable var textColor:UIColor = .black
    
    @IBInspectable var noLineColor:UIColor = .gray
    @IBInspectable var seLineColor:UIColor = .black
    @IBInspectable var bottomPading:CGFloat = 8
    
    /** 타이틀 라벨*/
    @IBOutlet weak var titleLabel: UILabel!
    /** 생년월일 (주민번호 앞자리)*/
    @IBOutlet weak var birthdayTextField: UITextField!
    /** 주민번호 뒷자리 입력 위한 컨테이너 뷰*/
    @IBOutlet weak var peopleNumberInputContainerView: UIView!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var topPaddingView: UIView!
    @IBOutlet weak var bottomPaddingLayout: NSLayoutConstraint!
    
    @IBOutlet weak var centerLineView: UIView!
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
    
    /** 생년월일 텍스트 필드*/
    public var firstTextField: UITextField {
        return birthdayTextField
    }
    
    func arrangeView() {
        guard let view = UINib(
                nibName: String(describing: NaruPeopleNumberInputView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        addGestureRecognizer(gesture)
        updateUI()
        
        birthdayTextField.rx.text.orEmpty.bind { [unowned self](string) in
            updateUI()
            if string.count > 6 {
                let txt = string[0..<6]
                birthdayTextField.endEditing(true)
                firstTextFieldCallBack(txt)
                birthdayTextField.text = txt
            }
        }.disposed(by: disposeBag)
        birthdayTextField.keyboardType = .numberPad
    }
        
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    private var firstTextFieldCallBack:(_ result:String)->Void = {_ in }
    public func onCompleteFirstTextFieldInput(callback:@escaping(_ result:String)->Void) {
        firstTextFieldCallBack = callback
    }

    public func setPeopleNumberInput(view:UIView?) {
        guard let view = view else {
            return
        }
        view.frame.size = peopleNumberInputContainerView.frame.size
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        peopleNumberInputContainerView.addSubview(view)
    }
    
    public var peopleNumberInputCount = 0
    
    
    public override var isFirstResponder: Bool {
        return birthdayTextField.isFirstResponder
    }
    
    public override var isFocused: Bool {
        peopleNumberInputCount + (birthdayTextField.text?.count ?? 0) != 0  || isFirstResponder
    }
    
    public var isFocusedForce:Bool = false {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.updateUI()
            }            
        }
    }
    
    func updateUI() {
        titleLabel.textColor = titleColor
        birthdayTextField.textColor = textColor
        centerLineView.backgroundColor = textColor
        
        bottomStackView.isHidden = !isFocused
        titleLabel.font = UIFont.systemFont(ofSize: isFocused ? 11 : 17)
        titleLabel.text = title
        if isRequired {
            let attr = title.makeRequiredAttributeString(textColor: titleColor, pointColor: requiredColor, height: titleLabel.font.pointSize)
            titleLabel.attributedText = attr
        }
        
        layer.cornerRadius = 2
        layer.borderColor = isFirstResponder || isFocusedForce == true ? seLineColor.cgColor : noLineColor.cgColor
        
        layer.borderWidth = 1
        topPaddingView.isHidden = !isFocused
        bottomPaddingLayout.constant = isFocused ? bottomPading : 0
    }
    
    @objc func onTap(_ sender:UITapGestureRecognizer) {
        birthdayTextField.becomeFirstResponder()
        updateUI()
    }
    
    
}
