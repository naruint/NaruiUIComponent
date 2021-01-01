//
//  NaruTextView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/04.
//

import UIKit
import RxSwift
import RxCocoa

//@IBDesignable
public class NaruTextView: UIView {
    let disposebag = DisposeBag()
    //MARK:-
    //MARK:IBOutlet
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    //MARK:-
    //MARK:IBInspectable
    @IBInspectable var placeholder:String? = nil {
        didSet {
            placeHolderLabel.text = placeholder
        }
    }
    @IBInspectable var text:String? {
        set {
            textView.text = newValue
        }
        get {
            textView.text
        }
    }
        
    @IBInspectable var buttonTitle:String? = nil {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
            button.isHidden = buttonTitle == nil
        }
    }
    /** 텍스트 입력 한계*/
    @IBInspectable var textlimit:Int = 100
    /** 보더 컬러*/
    @IBInspectable var normalBorderColor:UIColor = .gray
    /** 선택시 보더 컬러*/
    @IBInspectable var focusedBorderColor:UIColor = .black
    /** 텍스트 컬러*/
    @IBInspectable var textColor:UIColor? {
        set {
            textView.textColor = newValue
        }
        get {
            textView.textColor
        }
    }
    /** PlaceHolder  텍스트 컬러*/
    @IBInspectable var placeHolderColor:UIColor? {
        set {
            placeHolderLabel.textColor = newValue
        }
        get {
            placeHolderLabel.textColor
        }
    }
    
    /** 입력 제한 카운터 텍스트 앞쪽 컬러*/
    @IBInspectable var limitLabelColor1:UIColor = .black
    /** 입력 제한 카운터 텍스트 뒤쪽 컬러*/
    @IBInspectable var limitLabelColor2:UIColor = .gray
    
    public var inputText:String? {
        get {
            textView.text
        }
    }
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
                nibName: String(describing: NaruTextView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        DispatchQueue.main.async {[unowned self] in
            updateUI()
        }
        
        textView.rx.text.orEmpty.bind { [unowned self](string) in
            updateUI()
        }.disposed(by: disposebag)
        
        textView.delegate = self
        button.rx.tap.bind { [unowned self](_) in
            onTouchupButton(textView.text)
        }.disposed(by: disposebag)
    }
    
    private var onTouchupButton:(_ text:String?)->Void = { _ in
        // print("touchup button")
    }
    /** 하단 버튼 눌렀을 때 콜백*/
    public func onTouchupButton(didTouchup:@escaping(_ text:String?)->Void) {
        onTouchupButton = didTouchup
    }
    
    private func updateUI() {
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = textView.isFirstResponder ? focusedBorderColor.cgColor : normalBorderColor.cgColor
        placeHolderLabel.isHidden = !textView.text.isEmpty
        countLabel.attributedText = limitText
        
    }
    
    var limitText:NSAttributedString {
        let str = NSMutableAttributedString()
        str.append(NSAttributedString(string: "\(textView.text.count)", attributes: [.foregroundColor:limitLabelColor1]))
        str.append(NSAttributedString(string: " / \(textlimit)", attributes: [.foregroundColor:limitLabelColor2]))
        return str
    }
}

extension NaruTextView : UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        updateUI()
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        updateUI()
    }
}
