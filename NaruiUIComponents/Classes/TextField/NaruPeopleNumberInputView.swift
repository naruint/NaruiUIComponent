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
public class NaruPeopleNumberInputView: UIView {

    @IBInspectable var isRequired:Bool = false {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var requiredStrig:String = "*"
    @IBInspectable var requiredColor:UIColor = .green
    
    @IBInspectable var title:String = "" {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var noColor:UIColor = .gray
    @IBInspectable var seColor:UIColor = .black
    /** 타이틀 라벨*/
    @IBOutlet weak var titleLabel: UILabel!
    /** 생년월일 (주민번호 앞자리)*/
    @IBOutlet weak var birthdayTextField: UITextField!
    /** 주민번호 뒷자리 입력 위한 컨테이너 뷰*/
    @IBOutlet weak var peopleNumberInputContainerView: UIView!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var topPaddingView: UIView!
    
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
        }.disposed(by: disposeBag)
        birthdayTextField.keyboardType = .numberPad
    }



    public func setPeopleNumberInput(view:UIView?) {
        guard let view = view else {
            return
        }
        view.frame.size = peopleNumberInputContainerView.frame.size
        peopleNumberInputContainerView.addSubview(view)
    }
    
    public var peopleNumberInputCount = 0
    
    
    public override var isFirstResponder: Bool {
        return birthdayTextField.isFirstResponder
    }
    
    public override var isFocused: Bool {
        peopleNumberInputCount + (birthdayTextField.text?.count ?? 0) != 0  || isFirstResponder
    }
    
    
    func updateUI() {
        bottomStackView.isHidden = !isFocused
        titleLabel.font = UIFont.systemFont(ofSize: isFocused ? 11 : 17)
        let txt = NSMutableAttributedString()
        txt.append(NSAttributedString(string: title))
        if isRequired {
            txt.append(NSAttributedString(string: " \(requiredStrig)", attributes: [.foregroundColor:requiredColor]))
        }
        titleLabel.attributedText = txt
        
        layer.cornerRadius = 2
        layer.borderColor = isFocused ? seColor.cgColor : noColor.cgColor
        layer.borderWidth = 1
        topPaddingView.isHidden = !isFocused
    }
    
    @objc func onTap(_ sender:UITapGestureRecognizer) {
        birthdayTextField.becomeFirstResponder()
        updateUI()
    }
    
    
}
