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
        /** 감정 수치 0부터 100까지*/
        public var value:Int
        /** 감정 라벨 텍스트 */
        public let title:String
        /** 감정 수치 입력시 나오는 텍스트 */
        public let detailText:String
        /** 부정적인 감정인가? */
        public let isNegativeEmotion:Bool
        
        var mindHeaderString:String {
            if 1 <= value && value <= 20 {
                return "아주 조금\n"
            }
            if 21 <= value && value <= 40 {
                return "조금 "
            }
            if 41 <= value && value <= 60 {
                if isNegativeEmotion {
                    return "다소 "
                }
                return "나름 "
            }
            if 61 <= value && value <= 80 {
                return "많이 "
            }
            if 81 <= value && value <= 100 {
                return "아주 많이\n"
            }
            return ""
        }
        
        public init(value:Int, title:String, detailText:String, isNegativeEmotion:Bool) {
            self.value = value
            self.title = title
            self.detailText = detailText
            self.isNegativeEmotion = isNegativeEmotion
        }
    }

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBInspectable var mindColor:UIColor = .red
    @IBInspectable var forgroundColor:UIColor = .black
    @IBInspectable var isNegativeEmotion:Bool = false
    
    public var isEnabled = true {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
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
        return ViewModel(value: progress,
                         title: text ?? "",
                         detailText: detailText,
                         isNegativeEmotion: isNegativeEmotion)
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
        label.textColor = forgroundColor
        valueLabel.textColor = forgroundColor
        
    }  

    @IBAction func onTouchDownButton(_ sender: UIButton) {
        if isEnabled == false {
            isHighlighted = false
            return
        }
        isHighlighted = true
    }
    
    @IBAction func onTouthUpInsideButton(_ sender: UIButton) {
        isHighlighted = false
        if isEnabled == false {
            return
        }
        let vc = NaruMindColorValueSelectViewController.viewController
        vc.viewModel = viewModel
        print(" set value : \(viewModel.value)")
        vc.colors = [forgroundColor, mindColor]
        let tvc = targetViewController ?? UIApplication.shared.lastPresentedViewController
        tvc?.present(vc, animated: true, completion: {
            vc.updateUI(isForce: true)
        })
    }
    
    @IBAction func onTouchCancelButton(_ sender: UIButton) {
        isHighlighted = false
    }
    
    @IBAction func onTouchUpOutside(_ sender: UIButton) {
        isHighlighted = false
    }
    
    
}
