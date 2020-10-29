//
//  NaruSelectBoxView.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/28.
//

import UIKit

@IBDesignable
public class NaruSelectBoxView: UIView {
    
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
                nibName: String(describing: NaruSelectBoxView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        for btn in buttons {
            btn.addTarget(self, action: #selector(self.onButtonSelectChange(_:)), for: .touchUpInside)
            btn.setTitleColor(selectedColor, for: .selected)
            btn.setTitleColor(normalColor, for: .normal)
        }
        fixLayout()
    }
    
    
    @IBOutlet var buttons:[UIButton] = []
    @IBInspectable var titles:String = "" {
        didSet {
            for (index,title) in titles.components(separatedBy: ",").enumerated() {
                print(title)
                if index < buttons.count {
                    buttons[index].setTitle(title, for: .normal)
                }
            }
        }
    }
    
    @IBInspectable var selectedColor:UIColor?  {
        set {
            for btn in buttons {
                btn.setTitleColor(newValue, for: .selected)
            }
        }
        get {
            buttons.first?.titleColor(for: .selected) 
        }
    }
    
    @IBInspectable var normalColor:UIColor? {
        set {
            for btn in buttons {
                btn.setTitleColor(newValue, for: .normal)
            }
        }
        get {
            buttons.first?.titleColor(for: .normal)
        }
    }
    
    @IBAction func onTouchupButton(_ sender:UIButton) {
        if sender.isSelected {
            return
        }
        sender.isSelected = true
        sender.layer.zPosition = 1
        for btn in buttons {
            if btn != sender {
                btn.isSelected = false
                btn.layer.zPosition = 0
            }
        }
    }
    
    @objc func onButtonSelectChange(_ sender:UIButton) {
        fixLayout()
    }
    
    func fixLayout() {
        guard let selectedColor = selectedColor , let normalColor = normalColor else {
            return
        }
        for btn in buttons {
            btn.layer.borderWidth = 1
            btn.layer.borderColor = btn.isSelected ? selectedColor.cgColor : normalColor.cgColor
        }
    }
    
    public var selectedIndex:Int? {
        for (index,btn) in buttons.enumerated() {
            if btn.isSelected {
                return index
            }
        }
        return nil
    }
    
}
