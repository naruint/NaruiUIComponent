//
//  NaruCheckButton.swift
//  iOSSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/11/04.
//

import UIKit
import RxSwift
import RxCocoa

//@IBDesignable
public class NaruCheckButton: UIButton {
    let disposeBag = DisposeBag()
    //MARK:-
    //MARK:IBOutlet
    @IBOutlet weak var button: UIButton!

    //MARK:-
    //MARK:IBInspectable
    @IBInspectable var normalColor:UIColor = .white {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.setTintColor()
            }
        }
    }
    @IBInspectable var selectedColor:UIColor = .gray {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.setTintColor()
            }
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
                nibName: String(describing: NaruCheckButton.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        button.rx.tap.bind { [unowned self](_) in
            button.isSelected.toggle()
            button.tintColor = button.isSelected ? selectedColor : normalColor
        }.disposed(by: disposeBag)
        
        setTintColor()
        button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(button.image(for: .selected)?.withRenderingMode(.alwaysTemplate), for: .selected)
    }
    
    func setTintColor() {
        button.tintColor = button.isSelected ? selectedColor : normalColor
    }
}
