//
//  NaruImagePlaceHolderTextField.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/13.
//

import UIKit

class NaruImagePlaceHolderTextField: UIView {
    //MARK:-
    //MARK:IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
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
                nibName: String(describing: NaruImagePlaceHolderTextField.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
