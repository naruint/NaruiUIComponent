//
//  NaruImagePlaceHolderTextView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/13.
//

import UIKit
import RxCocoa
import RxSwift

@IBDesignable
/**
 PlaceHolder 를 이미지로 표시하는 텍스트뷰
 */
public class NaruImagePlaceHolderTextView: UIView {
    //MARK:-
    //MARK:IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lineView: UIView!
    //MARK:-
    //MARK:IBInspectable
    @IBInspectable var placeHolderImage: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            imageView.image
        }
    }
    
    @IBInspectable var textColor: UIColor? {
        set {
            textView.textColor = newValue
        }
        get {
            textView.textColor
        }
    }
    
    @IBInspectable var fontSize:CGFloat {
        set {
            textView.font = UIFont.systemFont(ofSize: newValue)
        }
        get {
            textView.font?.pointSize ?? 10
        }
    }
    
    @IBInspectable var lineColor: UIColor? {
        set {
            lineView.backgroundColor = newValue
        }
        get {
            lineView.backgroundColor
        }
    }

    public var text:String? {
        set {
            textView.text = newValue
        }
        get {
            textView.text
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
                nibName: String(describing: NaruImagePlaceHolderTextView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        textView.rx.text.orEmpty.bind { [unowned self](string) in
            updateUI()
        }.disposed(by: disposeBag)
        
        updateUI()
        textView.delegate = self
        lineView.isHidden = true
    }
    
    func updateUI() {
        imageView.isHidden = textView.text.isEmpty == false
    }
    
    let disposeBag = DisposeBag()

}

extension NaruImagePlaceHolderTextView : UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        lineView.isHidden = false
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        lineView.isHidden = true
    }
}
