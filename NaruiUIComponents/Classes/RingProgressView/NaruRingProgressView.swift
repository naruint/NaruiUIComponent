//
//  NaruRingProgressView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/24.
//

import UIKit
import MKRingProgressView

//@IBDesignable
public class NaruRingProgressView: UIView {
    public var viewModel:ViewModel? = ViewModel(secondLabelText: "", progress: 0.0, forgroundColor: .red, ringBackgrouncColor:.gray ) {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.updateUI()
            }
        }
    }
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet var innerCircleLayouts: [NSLayoutConstraint]!
    
    @IBInspectable var text:String = "" {
        didSet {
            viewModel?.secondLabelText = text
        }
    }
    
    @IBInspectable var innerPadding:CGFloat = 3
    @IBInspectable var ringWidth:CGFloat = 6
    @IBInspectable var forgroundColor:UIColor = .red
    
    @IBInspectable var titleFont:UIFont {
        set {
            firstLabel.font = newValue
        }
        get {
            return firstLabel.font
        }
    }
    
    @IBInspectable var descFont:UIFont {
        set {
            secondLabel.font = newValue
        }
        get {
            return secondLabel.font
        }
    }
    
    @IBInspectable var backgroundRingColor:UIColor = .gray
    
    @IBInspectable var firstTextColor:UIColor  {
        set {
            firstLabel.textColor = newValue
        }
        get {
            return firstLabel.textColor
        }
    }
    
    @IBInspectable var secondTextColor:UIColor {
        set {
            secondLabel.textColor = newValue
        }
        get {
            return secondLabel.textColor
        }
    }
    
    @IBOutlet weak var progressContainerView: UIView!
    
    public func setStyle(ringWidth:CGFloat,
                         innerPadding:CGFloat,
                         textColor:[UIColor], fonts:[UIFont]) {
        self.ringWidth = ringWidth
        self.innerPadding = innerPadding
        self.firstTextColor = textColor.first ?? .black
        self.secondTextColor = textColor.last ?? .black
        self.titleFont = fonts.first ?? UIFont.systemFont(ofSize: 20,weight: .bold)
        self.descFont = fonts.last ?? UIFont.systemFont(ofSize: 11, weight: .semibold)
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
    
    let progressView = RingProgressView()
    
    func arrangeView() {
        guard let view = UINib(
                nibName: String(describing: NaruRingProgressView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        progressView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        progressView.frame.size = progressContainerView.frame.size
        progressContainerView.addSubview(progressView)
        updateUI()
    }
    
    //MARK: -
    func updateUI() {
        progressView.startColor = forgroundColor
        progressView.endColor = forgroundColor
        bgImageView.image = forgroundColor.circleImage(diameter: 300)
        progressView.backgroundRingColor = backgroundRingColor

        progressView.shadowOpacity = 0.0
        guard let data = viewModel else {
            return
        }
        
        progressView.progress = Double(data.progress)
        firstLabel.text = data.firstLabelText
        secondLabel.text = data.secondLabelText
        secondLabel.isHidden = data.secondLabelText.isEmpty == true
        progressView.ringWidth = ringWidth
        for layout in innerCircleLayouts {
            layout.constant = ringWidth + innerPadding
        }
        
        progressView.startColor = data.forgroundColor
        progressView.endColor = data.forgroundColor
        bgImageView.image = data.forgroundColor.circleImage(diameter: 300)
        progressView.backgroundRingColor = data.ringBackgrouncColor
    
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
}
