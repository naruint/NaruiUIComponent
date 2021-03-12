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
    static let naruVideoPlayerStatusDidChange = Notification.Name(rawValue: "naruVideoPlayerStatusDidChange_observer")
    /** 제생 */
    static let naruVideoPlayerPlayButtonTouchup = Notification.Name(rawValue: "naruVideoPlayerPlayButtonTouchup_observer")
    /** 멈춤*/
    static let naruVideoPlayerPauseButtonTouchup = Notification.Name(rawValue: "naruVideoPlayerPauseButtonTouchup_observer")
    /** 설명 건너뛰기 버튼 */
    static let naruVideoPlayerSkipDescButtonTouchup = Notification.Name(rawValue: "naruVideoPlayerSkipDescButtonTouchup_observer")
    
}
public class NaruVideoControllerView: UIView {
    //MARK:Layout
    
    @IBOutlet weak var layoutBackBtnLeading: NSLayoutConstraint!
    @IBOutlet weak var layoutFullScreenButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var layoutDurationLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var layoutCurrentTimeLeading: NSLayoutConstraint!
    public var isFitPlayerLayerInVideoFrame = false
    public var isDisableSkipDescButton = false
    public var isAllowPIP:Bool = false
    public var kvoRateContext = 0
    public var avPlayer:AVPlayer? = nil {
        didSet {
            DispatchQueue.main.async {[weak self]in
                if let avlayer = self?.layer.sublayers?.first as? AVPlayerLayer {
                    avlayer.removeFromSuperlayer()
                }
                if let avPlayer = self?.avPlayer {
                    let avlayerLayer = AVPlayerLayer(player: avPlayer)
                    avlayerLayer.frame = self?.bounds ?? .zero
                    avlayerLayer.frame.size.width = UIScreen.main.bounds.width
                    avlayerLayer.frame.origin.x = 0
                    self?.layer.insertSublayer(avlayerLayer, at: 0)
                }
            }
        }
    }
    private var duration:TimeInterval = 0
    
    private var currentTime:TimeInterval = 0
    
    deinit {
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
            DispatchQueue.main.async {[weak self]in
                if let vc = self?.fullScreenController as? NaruLandscapeVideoViewController {
                    self?.fullScreenButton.isHidden = vc.isLandscapeOnly
                    self?.backButton.isHidden = !vc.isLandscapeOnly
                }
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
    
    var subLandScapeController:NaruLandscapeVideoViewController? {
        if fullScreenController == nil {
            return NaruLandscapeVideoViewController()
        }
        return nil
    }
    
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
            DispatchQueue.main.async {[weak self]in
                self?.skipDescButton.isHidden = self?.isDisableSkipDescButton ?? true
            }
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
                NotificationCenter.default.post(name: .naruVideoPlayerPauseButtonTouchup, object: viewModel?.id )
            } else {
                if avPlayer?.currentItem?.currentTime().seconds ?? 0 > (avPlayer?.currentItem?.duration.seconds ?? 0) - 0.1 {
                    avPlayer?.seek(to: CMTime.zero, completionHandler: { (fin) in
                        avPlayer?.play()
                        NotificationCenter.default.post(name: .naruVideoPlayerPlayButtonTouchup, object: viewModel?.id)
                    })
                } else {
                    avPlayer?.play()
                    NotificationCenter.default.post(name: .naruVideoPlayerPlayButtonTouchup, object: viewModel?.id)
                }
            }
        }.disposed(by: disposeBag)
        
        backButton.rx.tap.bind {[unowned self] (_) in
            fullScreenController?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        fullScreenButton.rx.tap.bind {[unowned self] (_) in
            toggleFullScreen()
        }.disposed(by: disposeBag)

        skipDescButton.rx.tap.bind { [unowned self](_) in
            if let viewModel = viewModel {
                avPlayer?.seek(to: CMTime(seconds: viewModel.endDescTime, preferredTimescale: 1000), completionHandler: { (_) in
                    updateSlider()
                    NotificationCenter.default.post(name: .naruVideoPlayerSkipDescButtonTouchup, object: viewModel.id)
                })
                skipDescButton.alpha = 0
            }
        }.disposed(by: disposeBag)

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapGesture(_:)))
        
        self.addGestureRecognizer(tapGesture)
        
        slider.setThumbImage(UIColor.white.circleImage(diameter: 14), for: .normal)
        slider.setThumbImage(UIColor.white.circleImage(diameter: 14), for: .highlighted)
        slider.addTarget(self, action: #selector(self.onSliderValueChanged(slider:event:)), for: .valueChanged)
       
        backButton.isHidden = true
        print("video frame test --------------------------")
        print(self.frame.width)
        if isFitPlayerLayerInVideoFrame {
            if frame.width == 0 {
                layoutBackBtnLeading.constant = 34
                layoutFullScreenButtonTrailing.constant = 34
                layoutDurationLabelTrailing.constant = 44
                layoutCurrentTimeLeading.constant = 44
            } else {
                layoutBackBtnLeading.constant = 14
                layoutFullScreenButtonTrailing.constant = 14
                layoutDurationLabelTrailing.constant = 24
                layoutCurrentTimeLeading.constant = 24
            }
        }
        
        NotificationCenter.default.addObserver(forName: .naruVideoPlayerStatusDidChange, object: nil, queue: nil) { [weak self](noti) in
            self?.updateSlider()
        }
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
    
    public var orientation:UIInterfaceOrientation = .portrait {
        didSet {
            if oldValue != orientation {
                switch orientation {
                case .landscapeLeft:
                    setOrientation(mask: .landscapeLeft, rotateTo: .landscapeLeft)
                case .landscapeRight:
                    setOrientation(mask: .landscapeRight, rotateTo: .landscapeRight)
                default:
                    setOrientation(mask: .portrait, rotateTo: .portrait)
                }
            }
        }
    }
    
    func toggleFullScreen() {
        guard let vc = subLandScapeController else {
            self.fullScreenController?.dismiss(animated: true, completion: nil)
            NaruOrientationHelper.shared.lockOrientation(.portrait, andRotateTo: .portrait)
            return
        }
        vc.isLandscapeOnly = false
        vc.playerControllerView.avPlayer = avPlayer
        vc.playerControllerView.viewModel = viewModel
        vc.title = viewModel?.title
        vc.playerControllerView.titleLabel.text = viewModel?.title
        UIApplication.shared.lastPresentedViewController?.present(vc, animated: true, completion: nil)
        NaruOrientationHelper.shared.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    func setOrientation(mask:UIInterfaceOrientationMask, rotateTo:UIInterfaceOrientation) {
        switch mask {
        case .landscape, .landscapeRight, .landscapeLeft:
            if UIApplication.shared.lastPresentedViewController is NaruLandscapeVideoViewController {
                NaruOrientationHelper.shared.lockOrientation(mask, andRotateTo: rotateTo)
                return
            }
            if let vc = subLandScapeController {
                vc.isLandscapeOnly = false
                vc.playerControllerView.avPlayer = avPlayer
                vc.playerControllerView.viewModel = viewModel
                vc.title = viewModel?.title
                vc.playerControllerView.titleLabel.text = viewModel?.title
                fullScreenController = vc
                vc.modalPresentationStyle = .currentContext
                UIApplication.shared.lastPresentedViewController?.present(vc, animated: true, completion: nil)
                NaruOrientationHelper.shared.lockOrientation(mask, andRotateTo: rotateTo)
            }
        default:
            NaruOrientationHelper.shared.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                NaruOrientationHelper.shared.lockOrientation(.portrait, andRotateTo: .portrait)
            }
            if let vc = UIApplication.shared.lastPresentedViewController as? NaruLandscapeVideoViewController {
                vc.dismiss(animated: true) {
                    NaruOrientationHelper.shared.lockOrientation(.portrait, andRotateTo: .portrait)
                }
            }
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
        if Int(viewModel.startDescTime) == Int(currentTime) {
            hideDescButton = false
        }
        if Int(viewModel.startDescTime) + 9 == Int(currentTime) {
            hideDescButton = true
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
            if self?.avPlayer?.rate ?? 0 > 0  {
                self?.registRateObserver()
            }
            NotificationCenter.default.post(name: .naruVideoPlayerStatusDidChange, object: time)
            //            self?.updateSlider()
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
