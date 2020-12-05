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
    public var viewModel:ViewModel? = nil {
        didSet {
            titleLabel.text = viewModel?.title
        }
    }
    
    deinit {
        if landScapeVideoViewController != nil {
            landScapeVideoViewController = nil
        }
    }
    
    public weak var targetViewController:UIViewController? = nil
    @IBOutlet weak var skipDescButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var avControllContainerView: UIView!
    @IBOutlet weak var fullScreenButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    var landScapeVideoViewController:NaruLandscapeVideoViewController? = nil
    let loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var playerLayer:AVPlayerLayer? = nil
    
    public var isBackButtonHidden:Bool {
        set {
            backButton.isHidden = newValue
        }
        get {
            backButton.isHidden
        }
    }
    
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
        
    public func openVideo() {
        guard let url = viewModel?.url else {
            return
        }
        if NaruVideoPlayer.shared.player == nil {
            playerLayer = NaruVideoPlayer.shared.playVideo(webUrl: url.absoluteString, containerView: self)
        } else {
            playerLayer = NaruVideoPlayer.shared.makePlayerLayer(containerView: self)
        }
        updatePlayerLayerFrame()
        NaruVideoPlayer.shared.progress { [weak self] (videoStatus) in
//            self?.updateUI()
            self?.slider.setValue(Float(videoStatus.progress), animated: true)
            
            self?.playButton.isSelected = NaruVideoPlayer.shared.player?.isPlaying == true
            if self?.loadingView.isAnimating == true {
                self?.loadingControll(isLoading: false)
            }
        }
        loadingControll(isLoading: true)
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
    
    func updatePlayerLayerFrame()  {
        guard let playerLayer = self.playerLayer else {
            return
        }
        layer.insertSublayer(playerLayer, at: 0)
        playerLayer.frame = frame
        playerLayer.frame.origin = .zero
        print("updateFrame : \(playerLayer.frame)")
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
        if NaruVideoPlayer.shared.player == nil {
            titleLabel.text = nil
            durationLabel.text = nil
            currentTimeLabel.text = nil
            slider.isEnabled = false
            slider.value = 0
        }
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        
        slider.setThumbImage(UIColor.white.circleImage(diameter: 12), for: .normal)
        

        playButton.rx.tap.bind {[unowned self](_) in
            if NaruVideoPlayer.shared.isPlaying == true {
                NaruVideoPlayer.shared.pause()
                updateUI()
                playButton.isSelected = true
            } else {
                NaruVideoPlayer.shared.play()
                updateUI()
                playButton.isSelected = false
            }
        }.disposed(by: disposeBag)
        
        backButton.rx.tap.bind {[unowned self] (_) in
            NaruOrientationHelper.shared.lockOrientation(.portrait, andRotateTo: .portrait)
            targetViewController?.dismiss(animated: true, completion: nil)
            
        }.disposed(by: disposeBag)
        
        fullScreenButton.rx.tap.bind {[unowned self] (_) in
            if let vc = targetViewController as? NaruLandscapeVideoViewController {
                vc.playerControllerView.viewModel = self.viewModel
                
                NaruOrientationHelper.shared.lockOrientation(.portrait, andRotateTo: .portrait)
                DispatchQueue.main.async {
                    vc.dismiss(animated: true) {
                        updateUI()
                    }
                }
            } else {
                let landScape = self.landScapeVideoViewController ?? NaruLandscapeVideoViewController()
                landScape.playerControllerView.viewModel = self.viewModel
                landScape.playerControllerView.isBackButtonHidden = self.isBackButtonHidden
                self.landScapeVideoViewController = landScape
                landScape.modalTransitionStyle = .crossDissolve
                NaruOrientationHelper.shared.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
                DispatchQueue.main.async {
                    targetViewController?.present(landScape, animated: true) {
                        landScape.playerControllerView.openVideo()
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapGesture(_:)))
        
        self.addGestureRecognizer(tapGesture)
        
        slider.setThumbImage(UIColor.white.circleImage(diameter: 14), for: .normal)
        slider.setThumbImage(UIColor.white.circleImage(diameter: 14), for: .highlighted)
        slider.addTarget(self, action: #selector(self.onSliderValueChanged(slider:event:)), for: .valueChanged)
       
    }
    
    
    func updateUI(){
        guard let viewModel = self.viewModel, let item = NaruVideoPlayer.shared.player?.currentItem else {
            return
        }
        if let player = self.playerLayer {
            if player.superlayer != layer {
                layer.insertSublayer(player, at: 0)
                player.frame = frame
                player.frame.origin = .zero
            }
        }
        titleLabel.text = viewModel.title
        let duration = item.asset.duration.seconds
        let currentTime:TimeInterval = item.currentTime().seconds
        durationLabel.text = duration.formatted_ms_String
        currentTimeLabel.text = currentTime.formatted_ms_String
        if touchSliderLock == false {
            slider.setValue(Float(currentTime / duration), animated: true)
        }
       
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
                    guard let item = NaruVideoPlayer.shared.player?.currentItem else {
                        return
                    }
                    let newtime = item.duration.seconds * Double(slider.value)
                    NaruVideoPlayer.shared.player?.seek(to: CMTime(seconds: newtime, preferredTimescale: item.duration.timescale))
                    touchSliderLock = false
                default:
                    break
                }
            }
    }
    
    
    
}
