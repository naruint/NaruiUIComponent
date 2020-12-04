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
    weak var landScape:NaruLandscapeVideoViewController? = nil
    let loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    let timmer = NaruTimmer()
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
    
    static var player:AVPlayer? = nil
    var playerLayer:AVPlayerLayer? = nil
    
    public func openVideo(viewModel:ViewModel) {
//        if self.viewModel?.url != viewModel.url && self.viewModel != nil {
//            addVideoLayer()
//            NaruVideoControllerView.player?.prepareForInterfaceBuilder()
//            NaruVideoControllerView.player?.play()
//            return
//        }
        self.viewModel = viewModel
        let asset = AVAsset(url: viewModel.url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        NaruVideoControllerView.player = player
        makeVideoLayer()
        NaruVideoControllerView.player?.prepareForInterfaceBuilder()
        NaruVideoControllerView.player?.play()
        loadingView.startAnimating()
        playButton.isHidden = true
    }
    
    public func makeVideoLayer() {
        guard let player =  NaruVideoControllerView.player else {
            return
        }
        playerLayer = AVPlayerLayer(player: player)
        updatePlayerLayerFrame()
        layer.insertSublayer(playerLayer!, at: 0)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updatePlayerLayerFrame()
    }
    
    
    func updatePlayerLayerFrame()  {
        guard let playerLayer = self.playerLayer else {
            return
        }
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
        titleLabel.text = nil
        durationLabel.text = nil
        currentTimeLabel.text = nil
        slider.value = 0
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        
        slider.setThumbImage(UIColor.white.circleImage(diameter: 12), for: .normal)
        

        playButton.rx.tap.bind {[unowned self](_) in
            playButton.isSelected.toggle()
            if NaruVideoControllerView.player?.isPlaying == true {
                NaruVideoControllerView.player?.pause()
            } else {
                NaruVideoControllerView.player?.play()
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
                vc.dismiss(animated: true) {
                    checkTime = true
                    updateUI()
                }
            } else {
                let landScape = self.landScape ?? NaruLandscapeVideoViewController()
                landScape.playerControllerView.viewModel = self.viewModel
                self.landScape = landScape
                landScape.modalTransitionStyle = .crossDissolve
                NaruOrientationHelper.shared.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
                checkTime = false
                targetViewController?.present(landScape, animated: true) {
                    landScape.playerControllerView.makeVideoLayer()
                }
            }
        }.disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapGesture(_:)))
        
        self.addGestureRecognizer(tapGesture)
        
        slider.setThumbImage(UIColor.white.circleImage(diameter: 14), for: .normal)
        slider.setThumbImage(UIColor.white.circleImage(diameter: 14), for: .highlighted)
        slider.addTarget(self, action: #selector(self.onSliderValueChanged(slider:event:)), for: .valueChanged)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemPlaybackStalled, object: nil, queue: nil) { [weak self](noti) in
            self?.updateUI()
        }
        NotificationCenter.default.addObserver(forName: .AVPlayerItemTimeJumped, object: nil, queue: nil) { [weak self](noti) in
            guard let s = self, let item = noti.object as? AVPlayerItem else {
                return
            }
            self?.loadingView.stopAnimating()
            self?.playButton.isHidden = false
            s.playButton.isSelected = NaruVideoControllerView.player?.isPlaying == true
           
            if NaruVideoControllerView.player?.isPlaying == true {
                s.timmer.start()
                s.checkTime = true
            } else {
                s.timmer.stop()
                s.checkTime = false
            }
            if item.currentTime().seconds == item.duration.seconds {
                s.timmer.stop()
            }
        }
    }
    
    var checkTime:Bool = false {
        didSet {
            if checkTime == true {
                updateUI()
            }
        }
    }
    
    func updateUI(){
        guard let viewModel = self.viewModel, let item = NaruVideoControllerView.player?.currentItem else {
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
            slider.value = Float(currentTime / duration)
        }
//        if checkTime {
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {[weak self]in
//                self?.updateUI()
//            }
//        }
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
                    guard let item = NaruVideoControllerView.player?.currentItem else {
                        return
                    }
                    let newtime = item.duration.seconds * Double(slider.value)
                    NaruVideoControllerView.player?.seek(to: CMTime(seconds: newtime, preferredTimescale: item.duration.timescale))
                    touchSliderLock = false
                default:
                    break
                }
            }
    }
    
    
    
}
