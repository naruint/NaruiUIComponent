//
//  NaruSimplePinNumberView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/05.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
public class NaruSimplePinNumberView: UIView {
    //MARK:-
    //MARK:IBInspectable
    @IBInspectable var onColor:UIColor = .green
    @IBInspectable var offColor:UIColor = .gray
    @IBInspectable var isAutoFocus:Bool = false
    //MARK:-
    //MARK:IBOutlet
    @IBOutlet var circleViews: [UIView]!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    let disposeBag = DisposeBag()
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
                nibName: String(describing: NaruSimplePinNumberView.self),
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
        
        textField.rx.text.orEmpty.bind { [unowned self](string) in
            if string.count > circleViews.count {
                textField.text = string[0..<circleViews.count]
            }
            updateUI()
        }.disposed(by: disposeBag)
        
        textField.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapStackView(_:)))
        stackView.addGestureRecognizer(gesture)
    }
    
    
    private func updateUI() {
        let textCount = textField.text?.count ?? 0
        let limit = circleViews.count
        let count = textCount > limit ? limit : textCount
        
        for view in circleViews {
            view.backgroundColor = offColor
        }
        if limit > 0 {
            for i in 0..<count {
                circleViews[i].backgroundColor = onColor
            }
        }
    }
    
    @objc func onTapStackView(_ sender:UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }
}
