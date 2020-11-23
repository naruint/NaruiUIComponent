//
//  NaruMindColorButton.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/23.
//

import UIKit

public extension Notification.Name {
    static let naruMindColorValueDidUpdated = Notification.Name("naruMindColorValueDidUpdated_observer")
}


@IBDesignable
public class NaruMindColorButton: UIView {
    public weak var targetViewController:UIViewController? = nil
    
    public struct ViewModel {
        let value:Int
        let title:String
    }

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBInspectable var mindColor:UIColor = .red
    @IBInspectable var forgroundColor:UIColor = .black
    
    @IBInspectable var image:UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            imageView.image
        }
    }
    
    @IBInspectable var text:String? {
        set {
            label.text = newValue
        }
        get {
            label.text
        }
    }
    @IBInspectable var detailText:String = ""
    
    public var progress:Int = 0 {
        didSet {
            if progress > 0 {
                valueLabel.text = "\(progress)"
            } else {
                valueLabel.text = nil
            }
        }
    }
    
    public var viewModel:ViewModel {
        let title = button.title(for: .normal) ?? "0"
        
        return ViewModel(value: NSString(string: title).integerValue, title: text ?? "")
    }
    
    
    var isHighlighted:Bool = false {
        didSet {
            checkImageView.isHidden = !isHighlighted
            valueLabel.isHidden = isHighlighted
        }
    }
    //MARK: - arrangeView
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
                nibName: String(describing: NaruMindColorButton.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        NotificationCenter.default.addObserver(forName: .naruMindColorValueDidUpdated, object: nil, queue: nil) { [weak self](noti) in
            guard let s = self else {
                return
            }
            if let model = noti.object as? ViewModel {
                if model.title == s.text {
                    s.progress = model.value
                }
            }
        }
        checkImageView.isHidden = true
        
    }  

    @IBAction func onTouchDownButton(_ sender: UIButton) {
        isHighlighted = true
    }
    
    @IBAction func onTouthUpInsideButton(_ sender: UIButton) {
        isHighlighted = false
        let vc = NaruMindColorValueSelectViewController.viewController
        vc.colors = [forgroundColor, mindColor]
        vc.detailText = detailText
        vc.title = text
        let p = progress
        let tvc = targetViewController ?? UIApplication.shared.keyWindow?.rootViewController
        tvc?.present(vc, animated: true, completion: {
            vc.setValue(value: p)
        })
    }
    
    @IBAction func onTouchCancelButton(_ sender: UIButton) {
        isHighlighted = false
    }
    
    @IBAction func onTouchUpOutside(_ sender: UIButton) {
        isHighlighted = false
    }
    
    
}
