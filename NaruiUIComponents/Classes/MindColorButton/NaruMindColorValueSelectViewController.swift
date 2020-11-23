//
//  NaruMindColorValueSelectViewController.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/23.
//
import UIKit
import RxCocoa
import RxSwift

class NaruMindColorValueSelectViewController: UIViewController {
    var colors:[UIColor] = [
        .black, .red
    ] {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.updateUIColors()
            }
        }
    }

    public class var viewController:NaruMindColorValueSelectViewController {
        if #available(iOS 13.0, *) {
            return UIStoryboard(name: "NaruMindColorValueSelectViewController", bundle: Bundle(for: NaruMindColorValueSelectViewController.self)).instantiateViewController(identifier: "root")
        } else {
            return UIStoryboard(name: "NaruMindColorValueSelectViewController", bundle: Bundle(for: NaruMindColorValueSelectViewController.self)).instantiateViewController(withIdentifier: "root") as! NaruMindColorValueSelectViewController
        }
    }
    

    var detailText:String?
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var progressBgView: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var progressHeightLayout: NSLayoutConstraint!
    
    @IBOutlet weak var slider:UISlider!
    var isTouchOn:Bool = false
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.rx.value.bind { [weak self](float) in
            self?.value = Int(float * 100)
            self?.updateUI()
        }.disposed(by: disposeBag)
        slider.addTarget(self, action: #selector(self.onSliderValChanged(slider:event:)), for: .valueChanged)
    
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .began:
                    break
                case .moved:
                    break
                case .ended:
                    dismiss(animated: true, completion: nil)
                default:
                    break
                }
            }
    }


    func updateUIColors() {
        for view in [bgView, progressBgView] {
            view?.backgroundColor = colors.last
        }
        for label in [textLabel, valueLabel, descLabel] {
            label?.textColor = colors.first
        }
        slider.minimumTrackTintColor = colors.first
        slider.maximumTrackTintColor = colors.first
        slider.thumbTintColor = colors.first
    }
    
    private var value:Int = 0
    
    func setValue(value:Int) {
        self.value = value
        DispatchQueue.main.async {[weak self] in
            self?.updateUI(isForce: true)
        }
    }
    
    func updateUI(isForce:Bool = false) {
        let p:CGFloat = CGFloat(value)/100
        
        print(value)
        valueLabel.text = "\(value)"
        textLabel.text = detailText
        textLabel.alpha = p * 5
        valueLabel.alpha = p * 5
//        textLabel.isHidden = value == 0
//        valueLabel.isHidden = value == 0
        NotificationCenter.default.post(name: .naruMindColorValueDidUpdated, object: NaruMindColorButton.ViewModel(value: value, title: title!))
        progressHeightLayout.constant = view.frame.height * p
        if isForce {
            slider.value = Float(p)
            UIView.animate(withDuration: 0.25) {[weak self]in
                self?.view.layoutIfNeeded()
            }
        }
    }
}

