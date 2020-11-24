//
//  NaruRingProgressView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/24.
//

import UIKit
import MKRingProgressView

@IBDesignable
public class NaruRingProgressView: UIView {
    public struct ViewModel {
        public var secondLabelText:String
        public var progress:Float
        public var firstLabelText:String {
            let p = Int(progress * 100)
            return "\(p)"
        }
        public init(secondLabelText:String, progress:Float) {
            self.secondLabelText = secondLabelText
            self.progress = progress
        }
    }

    public var viewModel:ViewModel? = ViewModel(secondLabelText: "", progress: 0.0) {
        didSet {
            updateUI()
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
    @IBInspectable var ringWitth:CGFloat = 4 {
        didSet {
            progressView.ringWidth = ringWitth
            for layout in innerCircleLayouts {
                layout.constant = ringWitth + 6
            }
        }
    }
    
    @IBInspectable var forgroundColor:UIColor = .red {
        didSet {
            progressView.startColor = forgroundColor
            progressView.endColor = forgroundColor
            bgImageView.image = forgroundColor.circleImage(diameter: 300)
        }
    }
    
    @IBInspectable var backgroundRingColor:UIColor = .gray {
        didSet {
            progressView.backgroundRingColor = backgroundRingColor
        }
    }
    
    @IBInspectable var textColor:UIColor = .black {
        didSet {
            for label in [firstLabel, secondLabel] {
                label?.textColor = textColor
            }
        }
    }
    
    @IBOutlet weak var progressContainerView: UIView!
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
        
        updateUI()
        progressView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        progressView.frame.size = progressContainerView.frame.size
        progressContainerView.addSubview(progressView)
    }
    
    //MARK: -
    func updateUI() {
        guard let data = viewModel else {
            return
        }
        
        progressView.progress = Double(data.progress)
        firstLabel.text = data.firstLabelText
        secondLabel.text = data.secondLabelText
        secondLabel.isHidden = data.secondLabelText.isEmpty == true
        
    }
    
    
}
