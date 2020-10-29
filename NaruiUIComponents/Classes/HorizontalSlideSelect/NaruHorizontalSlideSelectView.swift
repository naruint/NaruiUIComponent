//
//  NaruHorizontalSlideSelectView.swift
//  UITest
//
//  Created by Changyeol Seo on 2020/10/12.
//

import UIKit
protocol NaruHorizontalSlideSelectViewDelegate : class {
    func focusChange(isOn:Bool)
    func selectItem(item:NaruHorizontalSlideSelectViewController.AnswerModel, isShow:Bool)
}

class NaruHorizontalSlideSelectView: UIView {
    weak var delegate:NaruHorizontalSlideSelectViewDelegate? = nil
    @IBOutlet weak var bottomLabelsContainerView: UIView!
    
    @IBOutlet weak var trackView: UIView!
    @IBOutlet weak var selectLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var stackView: NaruHorizontalSlideSelectStackView!
    
    @IBOutlet weak var selectLabelBgWidth: NSLayoutConstraint!
    @IBOutlet weak var selectLabelBgHeight: NSLayoutConstraint!
    @IBOutlet weak var selectLabelBgView: UIView!
    
    @IBOutlet weak var selectLabelBgPointView: UIView!
    @IBOutlet weak var trackHeight: NSLayoutConstraint!
    
    @IBOutlet var bottomLabels:[UILabel] = []
    var isOn:Bool = false
    var datas:[NaruHorizontalSlideSelectViewController.AnswerModel] = [] {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                stackView.title = datas[selectedIndex].title
                stackView.subTitle = datas[selectedIndex].subTitle
                makeTrackPointView()
                fixLayout(isOn: false)
            }
        }
    }
    
    fileprivate var _selectedIndex:Int = 0
    var selectedIndex:Int {
        set {
            if datas.count == 0 {
                return
            }
            let x:CGFloat = (trackView.frame.width / CGFloat(datas.count)) * CGFloat(newValue) - (trackView.frame.width / 2) + stackView.frame.width / 2
            selectLabelCenterX.constant = x
            print(datas[selectedIndex].title)
            stackView.title = datas[selectedIndex].title
            stackView.subTitle = datas[selectedIndex].subTitle
            DispatchQueue.main.async {[unowned self] in
                let newx:CGFloat = (trackView.frame.width / CGFloat(datas.count)) * CGFloat(newValue) - (trackView.frame.width / 2) + stackView.frame.width / 2
                selectLabelCenterX.constant = newx
                UIView.animate(withDuration: 0.25) {[unowned self] in
                    layoutIfNeeded()
                }
                setBottomLabelHidden()
            }
        }
        get {
            let x = selectLabelCenterX.constant
            let harf = trackView.frame.width / 2
            let w = trackView.frame.width / CGFloat(datas.count)
            let select = Int((x + harf) / w)
            print("select: \(select)")
            if select >= datas.count {
                _selectedIndex = datas.count - 1
            } else {
                _selectedIndex = select
            }
            return _selectedIndex
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrangeView()
    }
    
    func arrangeView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        stackView.delegate = self
        selectLabelBgPointView.alpha = 0
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: NaruHorizontalSlideSelectView.self), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    func fixLayout(isOn:Bool) {
        delegate?.focusChange(isOn: isOn)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {[unowned self] in
            let w = isOn ? 80: stackView.width
            selectLabelBgWidth.constant = w
            selectLabelBgHeight.constant = w
            trackHeight.constant = isOn ? 5 : 30
            for view in trackView.subviews {
                view.isHidden = isOn
            }
            UIView.animate(withDuration: 0.25) { [unowned self] in
                bottomLabelsContainerView.alpha = isOn ? 0 : 1
                selectLabelBgView.layer.cornerRadius = w/2
                selectLabelBgPointView.alpha = isOn ? 1 : 0
                selectLabelBgPointView.layer.cornerRadius = selectLabelBgPointView.frame.width / 2
                stackView.alpha = isOn ? 0.1
                    : 1
                trackView.layer.cornerRadius = isOn  ? 2.5 : 15
                layoutIfNeeded()
            } completion: {  [unowned self] (fin) in
                if fin {
                    self.isOn = isOn
                }
            }
        }
                
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {[unowned self] in
            makeTrackPointView()
            selectedIndex = _selectedIndex
        }
    }
    
    fileprivate func makeTrackPointView()  {
        if datas.count == 0 {
            return
        }
        let pointSize:CGFloat = 10
        for view in trackView.subviews {
            view.removeFromSuperview()
        }
        let interval = trackView.frame.width / CGFloat(datas.count)
        var x:CGFloat = interval / 2 - pointSize + 5

        for _ in datas {
            let view = UIView(frame: CGRect(
                                x: x,
                                y: trackView.frame.height/2 - 5,
                                width: pointSize,
                                height: pointSize))
            view.layer.cornerRadius = 5
            view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            trackView.addSubview(view)
            x += interval
        }
        
        for (index,label) in bottomLabels.enumerated() {
            switch index {
            case 0:
                label.text = datas.first?.title
            case 1:
                if datas.count > 2 {
                    label.isHidden = false
                    label.text = datas[datas.count/2].title
                } else {
                    label.isHidden = true
                }
            case 2:
                label.text = datas.last?.title
            default:
                break
            }
            label.sizeToFit()
            
        }
    }
    
    // 선택에 따라 하단 라벨 감추기
    func setBottomLabelHidden() {
        if selectedIndex == 0 {
            bottomLabels.first?.isHidden = true
        } else {
            bottomLabels.first?.isHidden = false
        }

        if selectedIndex == datas.count - 1 {
            bottomLabels.last?.isHidden = true
        } else {
            bottomLabels.last?.isHidden = false
        }
        
        bottomLabels[1].isHidden = true
        if datas.count > 2 {
            if selectedIndex != datas.count / 2 {
                bottomLabels[1].isHidden = false
            }
        }
    }
    
}

extension NaruHorizontalSlideSelectView : NaruHorizontalSlideSelectViewLabelDelegate {
    func touchesMoved(touches: Set<UITouch>) {
        if datas.count == 0 {
            return
        }
        if let x = touches.first?.location(in: self).x {
            let limit = self.trackView.frame.width / 2 + 20
            var value = x - limit
            let max = limit - stackView.frame.width / 2
            let min = -limit + stackView.frame.width / 2
            
            if value < min {
                value = min
            }
            else if value > max  {
                value  = max
            }
            selectLabelCenterX.constant = value //- stackView.frame.width / 2
            print("select : \(selectedIndex)")
            stackView.title = datas[selectedIndex].title
            stackView.subTitle = datas[selectedIndex].subTitle
        }
        setBottomLabelHidden()
        delegate?.selectItem(item: datas[selectedIndex], isShow: true)
    }
    
    func touchesBegan(touches: Set<UITouch>) {
        fixLayout(isOn: true)
        delegate?.selectItem(item: datas[selectedIndex], isShow: true)
    }
    

    func touchesEnded(touches: Set<UITouch>) {
        fixLayout(isOn: false)
        setBottomLabelHidden()
        delegate?.selectItem(item: datas[selectedIndex], isShow: false)
    }
}

protocol NaruHorizontalSlideSelectViewLabelDelegate: class {
    func touchesBegan(touches:Set<UITouch>)
    func touchesEnded(touches:Set<UITouch>)
    func touchesMoved(touches:Set<UITouch>)
}

class NaruHorizontalSlideSelectStackView:UIStackView {
    
    var width:CGFloat {
        let a = titleLabel.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: titleLabel.frame.height)).width + 20
        let b = subTitleLabel.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: subTitleLabel.frame.height)).width + 20
        if a > b {
            return a
        }
        return b
    }
    
    weak var delegate:NaruHorizontalSlideSelectViewLabelDelegate? = nil
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var subTitleLabel:UILabel!
    var title:String? = nil
    var subTitle:String? = nil
    
    var isPress:Bool = false {
        didSet {
            if title != nil {
                titleLabel.text = isPress ? "" : title!
            }
            if subTitle != nil {
                subTitleLabel.text = isPress ? "" : subTitle!
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        isPress = false
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel?.text = self?.title
            self?.subTitleLabel?.text = self?.subTitle
            self?.subTitleLabel?.isHidden = self?.subTitle?.isEmpty == true
        }
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesBegan(touches: touches)
        isPress = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesMoved(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesEnded(touches: touches)
        isPress = false
    }
}
