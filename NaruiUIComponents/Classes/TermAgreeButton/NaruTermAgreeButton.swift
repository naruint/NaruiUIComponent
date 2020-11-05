//
//  NaruTermAgreeButton.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/11/04.
//

import UIKit
import RxSwift
import RxCocoa

extension Notification.Name {
    static let naruTermAgreeSelectionChange = Notification.Name(rawValue: "naruTermAgreeSelectionChange_observer")
}

@IBDesignable
public class NaruTermAgreeButton: UIView {

    let disposeBag = DisposeBag()
    @IBInspectable var title:String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var isTotalAgree:Bool = false
    @IBInspectable var isSelected:Bool = false {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var subButtonBGColor:UIColor = UIColor(white: 249/255, alpha: 1.0)
    @IBInspectable var totalBGColor:UIColor = .white
    @IBInspectable var totalBorderColor:UIColor = UIColor(white: 220/255, alpha: 1.0)
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bgButton: UIButton!
    @IBOutlet weak var bgButtonTrailing: NSLayoutConstraint!
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
                nibName: String(describing: NaruTermAgreeButton.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                
        bgButton.rx.tap.bind { [unowned self](_) in
            isSelected.toggle()
            DispatchQueue.main.async {[unowned self]in
                NotificationCenter.default.post(name: .naruTermAgreeSelectionChange, object: self)
            }

        }.disposed(by: disposeBag)
        
        button.rx.tap.bind { [unowned self](_) in
            didTouchupRightBtn()
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(forName: .naruTermAgreeSelectionChange, object: nil, queue: nil) { [weak self](noti) in
            if let btn = noti.object as? NaruTermAgreeButton {
                if btn.isTotalAgree {
                    self?.isSelected = btn.isSelected
                }
                if self?.isTotalAgree == true && btn.isTotalAgree == false && btn.isSelected == false {
                    self?.isSelected = false
                }
            }
        }
        
        DispatchQueue.main.async {[unowned self] in 
            updateUI()
        }
    }

    func updateUI() {
        iconImageView.isHighlighted = isSelected
        button.isHidden = isTotalAgree
        bgButtonTrailing.constant = isTotalAgree ? 0 : button.frame.width
        if isTotalAgree {
            backgroundColor = totalBGColor
            layer.borderWidth = 1.0
            layer.borderColor = totalBorderColor.cgColor
        } else {
            backgroundColor = subButtonBGColor
        }
    }
    
    var didTouchupRightBtn:()->Void = {
        print("TouchUP")
    }
    public func didTouchupRightBtn(didTouch:@escaping()->Void){
        didTouchupRightBtn = didTouch
    }
}
