//
//  NaruSelectBoxView.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/28.
//

import UIKit

@IBDesignable
public class NaruSelectBoxView: UIView {
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
            btn.setTitleColor(selectedTColor, for: .selected)
            btn.setTitleColor(normalTColor, for: .normal)
        }
        fixLayout()
    }
    //MARK:-
    //MARK:IBOutlet
    
    @IBOutlet var buttons:[UIButton] = []
    //MARK:-
    //MARK:IBInspectable

    @IBInspectable var titles:String = "" {
        didSet {
            for (index,title) in titles.components(separatedBy: ",").enumerated() {
                // print(title)
                if index < buttons.count {
                    buttons[index].setTitle(title, for: .normal)
                }
            }
        }
    }
    
    @IBInspectable var selectedTColor:UIColor?  {
        set {
            for btn in buttons {
                btn.setTitleColor(newValue, for: .selected)
            }
        }
        get {
            buttons.first?.titleColor(for: .selected) 
        }
    }
    
    @IBInspectable var normalTColor:UIColor? {
        set {
            for btn in buttons {
                btn.setTitleColor(newValue, for: .normal)
            }
        }
        get {
            buttons.first?.titleColor(for: .normal)
        }
    }
    
    /** 선택했을 때 라인 컬러*/
    @IBInspectable var selectedLColor:UIColor = .white
    /** 미선택시 라인컬러 */
    @IBInspectable var normalLColor:UIColor = .gray
    
    //MARK:-
    //MARK:IBAction

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
    
    //MARK:-
    //MARK:custom methods

    @objc func onButtonSelectChange(_ sender:UIButton) {
        fixLayout()
    }
    
    func fixLayout() {
        for btn in buttons {
            btn.layer.borderWidth = 1
            btn.layer.borderColor = btn.isSelected ? selectedLColor.cgColor : normalLColor.cgColor
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
