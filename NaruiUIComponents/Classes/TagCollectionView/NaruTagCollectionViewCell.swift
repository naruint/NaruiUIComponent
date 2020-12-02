//
//  NaruTagCollectionViewCell.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/26.
//

import UIKit

public class NaruTagCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        arrangeView()
    }
        
    
    func arrangeView() {
        label.frame.size = self.frame.size
        addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        label.textAlignment = .center
        layer.cornerRadius = 2
        layer.borderWidth = 2
        setColor()
    }

    public var text:String? {
        set {
            label.text = newValue
        }
        get {
            label.text
        }
    }
        
    
    func setColor(textColor:UIColor = .black, borderColor:UIColor = .red, bgColor:UIColor = .orange) {
        label.textColor = textColor
        layer.borderColor = borderColor.cgColor
        backgroundColor = bgColor
    }

    
}
