//
//  NaruGraphItemView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/12.
//

import UIKit
import RxCocoa
import RxSwift
extension Notification.Name {
    static let naruGraphItemDidSelected = Notification.Name(rawValue: "naruGraphItemDidSelected_observer")
}
class NaruGraphItemView: UIView {

    var data:NaruGraphView.Data? = nil {
        didSet {
            DispatchQueue.main.async {[weak self]in
                guard let s = self else {
                    return
                }
                let height = s.frame.height - s.weakDayLabel.frame.height - s.dayLabel.frame.height
                
                if let value = s.data?.value {
                    let newHeigt = height * CGFloat(value)
                    s.layoutBarHeight.constant = newHeigt
                }
                s.dayLabel.text = "\(s.data?.date.day ?? 0)"
                s.weakDayLabel.text = s.data?.date.dayWeakString
            }
        }
    }
    let disposeBag = DisposeBag()
    
    //MARK:-
    //MARK:IBOutlet
    @IBOutlet weak var buttonView: UIButton!
    @IBOutlet weak var layoutBarHeight: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var weakDayLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
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
                    nibName: String(describing: NaruGraphItemView.self),
                    bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
                return
            }
            view.frame = bounds
            addSubview(view)
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            buttonView.setBackgroundImage(UIColor.yellow.image, for: .normal)
            buttonView.setBackgroundImage(UIColor.green.image, for: .selected)
            buttonView.rx.tap.bind { [unowned self](_) in
                NotificationCenter.default.post(name: .naruGraphItemDidSelected, object: self.data)
                buttonView.isSelected = true
            }.disposed(by: disposeBag)
            
            NotificationCenter.default.addObserver(forName: .naruGraphItemDidSelected, object: nil, queue: nil) { (noti) in
                if let obj = noti.object as? NaruGraphView.Data {
                    if self.data?.date.day == obj.date.day {
                        return
                    }
                    self.buttonView.isSelected = false
                }
            }
        }

}
