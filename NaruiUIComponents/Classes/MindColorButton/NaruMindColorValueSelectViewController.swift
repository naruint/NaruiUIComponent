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
    

    var viewModel:NaruMindColorButton.ViewModel? = nil
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var progressBgView: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var bgView2: UIView!
    
    @IBOutlet weak var progressHeightLayout: NSLayoutConstraint!
    
    @IBOutlet weak var slider:UISlider!
    var isTouchOn:Bool = false
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.rx.value.changed.bind { [weak self](float) in
            self?.viewModel?.value = Int(float * 100)
            self?.updateUI()
        }.disposed(by: disposeBag)
        slider.addTarget(self, action: #selector(self.onSliderValChanged(slider:event:)), for: .valueChanged)
    
        // Do any additional setup after loading the view.
        updateUI(isForce: true)
        textLabel.alpha = 0
        valueLabel.alpha = 0
        if viewModel?.value ?? 0 > 0 {
            showup()
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapView(_:)))
        self.view.addGestureRecognizer(gesture)
        NotificationCenter.default.post(name: .naruMindColorValueChangeControllerDidLoaded, object: nil)
    }
    
    @objc func onTapView(_ sender:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showup() {
        progressHeightLayout.constant = view.frame.height
        UIView.animate(withDuration: 0.25) {[weak self]in
            self?.view.layoutIfNeeded()
            self?.textLabel.alpha = 1
            self?.valueLabel.alpha = 1
            self?.descLabel.textColor = self?.colors.first ?? .black
        }
    }
    
        
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            NotificationCenter.default.post(name: .naruMindColorValueChangeControllerDidDismissed, object: self.viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .began:
                    showup()
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
        
        for view in [bgView, progressBgView, bgView2] {
            view?.backgroundColor = colors.last
        }
        for label in [textLabel, valueLabel] {
            label?.textColor = colors.first
        }
        slider.minimumTrackTintColor = colors.first
        slider.maximumTrackTintColor = colors.first?.withAlphaComponent(0.2)
        slider.thumbTintColor = colors.first
        if let model = viewModel {
            let normalImage = colors.first!.circleImage(diameter: 40, innerColor: model.mindColor, innerDiameter: 8)
            let highlightedImage = colors.first!.circleImage(diameter: 55, innerColor: model.mindColor, innerDiameter: 18)
            
            slider.setThumbImage(normalImage, for: .normal)
            slider.setThumbImage(highlightedImage, for: .highlighted)
        }
    }
        
    func setValue(value:Int) {
        self.viewModel?.value = value
        DispatchQueue.main.async {[weak self] in
            self?.updateUI(isForce: true)
        }
    }
    
   
    
    func updateUI(isForce:Bool = false) {
        guard let model = self.viewModel else {
            // print("view model not set")
            return
        }
        // print("\(#function) value : \(model.value)")
        let p:CGFloat = CGFloat(model.value)/100
        valueLabel.text = "\(model.value)"
        textLabel.text = model.mindHeaderString + model.detailText
        if isForce {
            slider.value = Float(p)
            UIView.animate(withDuration: 0.25) {[weak self]in
                self?.view.layoutIfNeeded()
            }
        }
        else {
            NotificationCenter.default.post(name: .naruMindColorValueDidUpdated, object: viewModel)
        }
    }
}

