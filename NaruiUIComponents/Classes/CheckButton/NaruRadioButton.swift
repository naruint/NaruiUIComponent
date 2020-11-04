//
//  NaruRadioButton.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/04.
//

import UIKit
import RxSwift
import RxCocoa

extension Notification.Name {
    static let naruRadioButtonSelect = Notification.Name(rawValue: "naruRadioButtonSelect_observer")
}

@IBDesignable
public class NaruRadioButton: UIView {
    @IBInspectable var idx:Int = 0
    @IBInspectable var groupid:String? = nil
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var button:UIButton!
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
                nibName: String(describing: NaruRadioButton.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        button.rx.tap.bind { [unowned self](_) in
            button.isSelected = true
            NotificationCenter.default.post(name: .naruRadioButtonSelect, object: idx)
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(forName: .naruRadioButtonSelect, object: nil, queue: nil) { [weak self](noti) in
            if noti.object as? Int != self?.idx {
                self?.button.isSelected = false
            }
        }
    }

}
