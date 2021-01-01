//
//  NaruTwoDepthFilterView.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/27.
//

import UIKit
//@IBDesignable
public class NaruTwoDepthFilterView: UIView {

    public var data:ViewModel? = nil
    
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
                nibName: String(describing: NaruTwoDepthFilterView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
