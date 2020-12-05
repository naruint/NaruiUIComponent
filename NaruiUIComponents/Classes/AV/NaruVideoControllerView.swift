//
//  NaruVideoView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/12/04.
//

import UIKit
import RxCocoa
import RxSwift
import AVKit
import NVActivityIndicatorView

public class NaruVideoControllerView: UIView {
    public var kvoRateContext = 0
    var avPlayer:AVPlayer? = nil {
        didSet {
            if let avlayer = layer.sublayers?.first as? AVPlayerLayer {
                avlayer.removeFromSuperlayer()
            }
            let avlayer = AVPlayerLayer(player: avPlayer)
            avlayer.frame = bounds
            layer.insertSublayer(avlayer, at: 0)
        }
    }
    
    deinit {
        print("deinit NaruVideoControllerView")
    }
    
    public var isPlaying:Bool {
        return avPlayer?.rate != 0 && avPlayer?.error == nil
    }
    
    var viewModel:NaruVideoControllerView.ViewModel? = nil
    weak var fullScreenController:UIViewController? = nil {
        didSet {
            if let vc = fullScreenController as? NaruLandscapeVideoViewController {
                fullScreenButton.isHidden = vc.isLandscapeOnly
                backButton.isHidden = !vc.isLandscapeOnly
            }
        }
    }
    
    @IBOutlet weak var skipDescButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var avControllContainerView: UIView!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    let loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
        
    let disposeBag = DisposeBag()
    var touchSliderLock = false
    
    var hideDescButton = true {
        didSet {
            if oldValue != hideDescButton {
                UIView.animate(withDuration: 0.5) {[weak self]in
                    self?.skipDescButton.alpha = self?.hideDescButton ?? false ? 0 : 1
                }
            }
        }
    }
        
    
    private func loadingControll(isLoading:Bool) {
        if isLoading {
            loadingView.startAnimating()
            playButton.isHidden = true
            slider.isEnabled = false
            fullScreenButton.isEnabled = false
        }
        else {
            loadingView.stopAnimating()
            playButton.isHidden = false
            slider.isEnabled = true
            fullScreenButton.isEnabled = true
        }
    }
    
    func initUI() {
        guard let view = UINib(
                nibName: String(describing: NaruVideoControllerView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(loadingView)
        playButton.layer.zPosition = 100
        titleLabel.text = nil
        durationLabel.text = nil
        currentTimeLabel.text = nil
        slider.isEnabled = false
        slider.value = 0
        skipDescButton.alpha = 0
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        
        slider.setThumbImage(UIColor.white.circleImage(diameter: 12), for: .normal)
        

        playButton.rx.tap.bind {[unowned self](_) in
            if avPlayer?.isPlaying == true {
                avPlayer?.pause()
            } else {
                avPlayer?.play()
            }
        }.disposed(by: disposeBag)
        
        backButton.rx.tap.bind {[unowned self] (_) in
            fullScreenController?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        fullScreenButton.rx.tap.bind {[unowned self] (_) in
            if let vc = fullScreenController {
                vc.dismiss(animated: true, completion: nil)
            } else {
                let vc = NaruLandscapeVideoViewController()
                vc.isLandscapeOnly = false
                vc.playerControllerView.avPlayer = avPlayer
                vc.playerControllerView.viewModel = viewModel
                vc.title = viewModel?.title
                vc.playerControllerView.titleLabel.text = viewModel?.title
                UIApplication.shared.lastPresentedViewController?.present(vc, animated: true, completion: nil)
            }

        }.disposed(by: disposeBag)

        skipDescButton.rx.tap.bind { [unowned self](_) in
            if let viewModel = viewModel {
                avPlayer?.seek(to: CMTime(seconds: viewModel.endDescTime, preferredTimescale: 1000), completionHandler: { (_) in
                    updateSlider()
                })
            }
        }.disposed(by: disposeBag)

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapGesture(_:)))
        
        self.addGestureRecognizer(tapGesture)
        
        slider.setThumbImage(UIColor.white.circleImage(diameter: 14), for: .normal)
        slider.setThumbImage(UIColor.white.circleImage(diameter: 14), for: .highlighted)
        slider.addTarget(self, action: #selector(self.onSliderValueChanged(slider:event:)), for: .valueChanged)
       
    }
    

    var tapLock = false
    @objc func onTapGesture(_ gesture:UITapGestureRecognizer) {
        let toAlpha:CGFloat = avControllContainerView.alpha == 0 ? 1 : 0
        if tapLock {
            return
        }
        tapLock = true
        UIView.animate(withDuration: 0.25) {[weak self]in
            self?.avControllContainerView.alpha = toAlpha
        } completion: { [weak self] _ in
            self?.tapLock = false
        }

    }
    
    @objc func onSliderValueChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
                switch touchEvent.phase {
                case .began:
                    touchSliderLock = true
                case .ended:
                    guard let item = avPlayer?.currentItem else {
                        touchSliderLock = false
                        return
                    }
                    let newtime = item.duration.seconds * Double(slider.value)
                    avPlayer?.seek(to: CMTime(seconds: newtime, preferredTimescale: item.duration.timescale))
                    touchSliderLock = false
                default:
                    break
                }
            }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let context = context else {
            return
        }
        switch context {
        case &kvoRateContext:
            updatePlayBtn()
        default:
            break
        }
    }
    
    func updatePlayBtn() {
        playButton.isSelected = isPlaying
    }
    
    func updateSlider() {
        guard let item = avPlayer?.currentItem , let viewModel = viewModel else {
            return
        }
        let currentTime = item.currentTime().seconds
        let duration = item.duration.seconds
        slider.isEnabled = true
        if touchSliderLock == false {
            slider.setValue(Float(currentTime / duration), animated: true)
        }
        currentTimeLabel.text = currentTime.formatted_ms_String
        durationLabel.text = duration.formatted_ms_String
        
        hideDescButton = !(viewModel.startDescTime < currentTime && currentTime <= viewModel.endDescTime)
    }
    
        
    public func openVideo(viewModel:ViewModel) {
        self.viewModel = viewModel
        let avPlayer = AVPlayer(url: viewModel.url)
        titleLabel.text = viewModel.title
        self.avPlayer = avPlayer
        addObserver()
        updateSlider()
        updatePlayBtn()
    }
    
    public func addObserver() {
        avPlayer?.addObserver(self, forKeyPath: "rate", options: .new, context: &kvoRateContext)
        avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1000), timescale: 1000), queue: nil, using: { [weak self](time) in
            self?.updateSlider()
        })
    }
}
