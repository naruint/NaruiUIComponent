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
public extension Notification.Name {
    /** 비디오 시청 시간 측정값을 리턴하는 notification */
    static let naruVideoWatchFinished = Notification.Name(rawValue: "naruVideoWatchFinished_observer")
}
public class NaruVideoControllerView: UIView {
    public var isAllowPIP:Bool = false
    public var kvoRateContext = 0
    public var avPlayer:AVPlayer? = nil {
        didSet {
            if let avlayer = layer.sublayers?.first as? AVPlayerLayer {
                avlayer.removeFromSuperlayer()
            }
            let avlayer = AVPlayerLayer(player: avPlayer)
            avlayer.frame = bounds
            avlayer.frame.size.width = UIScreen.main.bounds.width
            avlayer.frame.origin.x = 0
            layer.insertSublayer(avlayer, at: 0)
        }
    }
    private var duration:TimeInterval = 0
    
    private var currentTime:TimeInterval = 0
    
    deinit {
        subLandScapeController = nil
        reportPlayTime()
        NaruVideoControllerView.bgPlayerView.player = nil
        // print("deinit NaruVideoControllerView")
    }
    
    func reportPlayTime() {
        NaruTimmer.videoTimer.stop()
        if let model = viewModel {
            if NaruTimmer.videoTimer.timeResult > 0 {
                let result = ResultModel(
                    id: model.id,
                    midaDvcd: model.mdiaDvcd,
                    title: model.title,
                    watchTime: NaruTimmer.videoTimer.timeResult,
                    currentTime: currentTime,
                    duration: duration)
                NotificationCenter.default.post(
                    name: .naruVideoWatchFinished,
                    object: result)
                // print("시청시간 : \(NaruTimmer.shared.timeResult)")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            NaruTimmer.videoTimer.reset()
        }
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
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var skipDescButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var avControllContainerView: UIView!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var subLandScapeController:NaruLandscapeVideoViewController? = nil
    
    let loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
    static let bgPlayerView = AVPlayerViewController()
    
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
        durationLabel.textColor = UIColor.white
        currentTimeLabel.textColor = UIColor.white
        playButton.layer.zPosition = 100
        titleLabel.text = currentTime.formatted_ms_String
        durationLabel.text = duration.formatted_ms_String ?? "00:00"
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
                if avPlayer?.currentItem?.currentTime().seconds ?? 0 > (avPlayer?.currentItem?.duration.seconds ?? 0) - 0.1 {
                    avPlayer?.seek(to: CMTime.zero, completionHandler: { (fin) in
                        avPlayer?.play()
                    })
                } else {
                    avPlayer?.play()
                }
            }
        }.disposed(by: disposeBag)
        
        backButton.rx.tap.bind {[unowned self] (_) in
            fullScreenController?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        fullScreenButton.rx.tap.bind {[unowned self] (_) in
            if let vc = fullScreenController {
                
                vc.dismiss(animated: true, completion: nil)
            } else {
                let vc = subLandScapeController ?? NaruLandscapeVideoViewController()
                if subLandScapeController == nil {
                    subLandScapeController = vc
                } else {
                    NaruOrientationHelper.shared.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
                }
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
       
        backButton.isHidden = true
    }
    
    func initPIP() {
        if isAllowPIP == false {
            return
        }
        if #available(iOS 14.2, *) {
            NaruVideoControllerView.bgPlayerView.player = avPlayer
            NaruVideoControllerView.bgPlayerView.canStartPictureInPictureAutomaticallyFromInline = true
            NaruVideoControllerView.bgPlayerView.allowsPictureInPicturePlayback = true
            NaruVideoControllerView.bgPlayerView.updatesNowPlayingInfoCenter = true
            addSubview(NaruVideoControllerView.bgPlayerView.view)
            NaruVideoControllerView.bgPlayerView.view.alpha = 0
            NaruVideoControllerView.bgPlayerView.view.frame = frame
        }
    }
    
   
    
    
    
    var avControllContainerViewHide = false {
        didSet {
            if oldValue != avControllContainerViewHide {
                let toAlpha:CGFloat = avControllContainerViewHide ? 0 : 1
                tapLock = true
                UIView.animate(withDuration: 0.25) {[weak self]in
                    self?.avControllContainerView.alpha = toAlpha
                } completion: { [weak self] _ in
                    self?.tapLock = false
                }
            }
            if avControllContainerViewHide {
                hideDescButton = true
            } else {
                let s = self.viewModel?.startDescTime ?? -1
                let e = self.viewModel?.endDescTime ?? -1
                let t = self.currentTime
                hideDescButton = !(s < t && t <= e)
            }
        }
    }

    var tapLock = false
    @objc func onTapGesture(_ gesture:UITapGestureRecognizer) {
        if tapLock {
            return
        }
        avControllContainerViewHide.toggle()
        if avControllContainerViewHide == false {
            lastControllViewShowupTime = Date()
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
                if avPlayer?.error != nil || durationLabel.text == "00:00"{
                    slider.setValue(0, animated: true)
                    touchSliderLock = false
                    return
                }
                let newtime = item.duration.seconds * Double(slider.value)
                avPlayer?.seek(to: CMTime(seconds: newtime, preferredTimescale: item.duration.timescale))
                touchSliderLock = false
            default:
                print(slider.value)
                currentTimeLabel.text = (duration * Double(slider.value)).formatted_ms_String
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
    
    var lastControllViewShowupTime:Date? = nil
    
    func updatePlayBtn() {
        if isPlaying == false {
            NaruTimmer.videoTimer.stop()
            reportPlayTime()
        } else {
            NaruTimmer.videoTimer.start()
            lastControllViewShowupTime = Date()
        }
        playButton.isSelected = isPlaying
    }
    
    func updateSlider() {
        guard let item = avPlayer?.currentItem , let viewModel = viewModel else {
            return
        }
        
        let currentTime = item.currentTime().seconds
        self.currentTime = currentTime
        let duration = item.duration.seconds
        self.duration = duration
        if touchSliderLock == false {
            slider.setValue(Float(currentTime / duration), animated: true)
            currentTimeLabel.text = currentTime.formatted_ms_String
        }
        slider.isEnabled = duration > 0

        durationLabel.text = duration.formatted_ms_String ?? viewModel.duration.formatted_ms_String
        
        if avControllContainerViewHide == false {
            hideDescButton = !(viewModel.startDescTime < currentTime && currentTime <= viewModel.endDescTime)
        }
        
        if let lastTime = lastControllViewShowupTime?.timeIntervalSince1970 {
            let now = Date().timeIntervalSince1970
            if now - lastTime > 5  {
                avControllContainerViewHide = true
                lastControllViewShowupTime = nil
            }
        }
    }
    
    public func setThumbImage(url:URL?, placeHolder:UIImage?) {
        thumbImageView.isHidden = url == nil
        thumbImageView.frame.size = thumbImageView.superview?.frame.size ?? .zero
        thumbImageView.frame.origin = .zero
        thumbImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if thumbImageView.frame.size.height == UIScreen.main.bounds.size.height {
            thumbImageView.contentMode = .scaleAspectFit
        } else {
            thumbImageView.contentMode = .scaleAspectFill
        }
        thumbImageView.kf.setImage(with: url, placeholder: placeHolder, options: nil, progressBlock: nil) { [weak self](result) in
            self?.thumbImageView.isHidden =  self?.thumbImageView.image == nil
        }
    }
        
    public func openVideo(viewModel:ViewModel) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
          try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
          print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        if thumbImageView.image == nil {
            setThumbImage(url: viewModel.thumbnailURL, placeHolder: nil)
        }
        
        NaruTimmer.videoTimer.reset()
        self.viewModel = viewModel
        let avPlayer = AVPlayer(url: viewModel.url)
        titleLabel.text = viewModel.title
        durationLabel.text = viewModel.duration.formatted_ms_String
        self.avPlayer = avPlayer
        if viewModel.currentTime > 0 {
            self.avPlayer?.seek(to: CMTime(seconds: viewModel.currentTime, preferredTimescale: 1000))
        }
//        let pi = UIColor.white.image
        
//        NowPlayUtill.setupNowPlaying(
//            title: viewModel.title,
//            subTitle: "",
//            artworkImageURL: viewModel.thumbnailURL,
//            artworkImagePlaceHolder: pi,
//            currentTime: viewModel.currentTime,
//            duration: TimeInterval(avPlayer.currentItem?.duration.seconds ?? viewModel.duration ),
//            rate: avPlayer.rate)

        addObserver()
        updateSlider()
        updatePlayBtn()
        initPIP()
    }

    public func addObserver() {
        avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1000), timescale: 1000), queue: nil, using: { [weak self](time) in
            UIView.animate(withDuration: 0.25) {
                self?.thumbImageView.alpha = 0
            }
            self?.updateSlider()
            if self?.avPlayer?.rate ?? 0 > 0  {
                self?.registRateObserver()
            }
        })
    }

    public func seek(second:Double) {
        let time:CMTime = CMTime(seconds: second, preferredTimescale: 1000)
        avPlayer?.seek(to: time)
        slider.value = Float(second / duration)
    }
    
    var isRegistRateObserver = false
    func registRateObserver() {
        if isRegistRateObserver == false {
            avPlayer?.addObserver(self, forKeyPath: "rate", options: .new, context: &kvoRateContext)
            updatePlayBtn()
            isRegistRateObserver = true
        }
    }
    
   
}
