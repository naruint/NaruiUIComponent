//
//  NaruMusicPlayerMiniView.swift
//  NaruiUIComponents
//
//  Created by Changyul Seo on 2020/11/28.
//

import UIKit
import MKRingProgressView
import RxCocoa
import RxSwift


public extension Notification.Name {
    static let naruMusicPlayerMiniCotrollerMessage = Notification.Name("naruMusicPlayerMiniCotrollerMessage_observer")
}

//@IBDesignable
public class NaruMusicPlayerMiniView: UIView {
    private weak var superTabbarController : UITabBarController? = nil
    private weak var superViewController: UIViewController? = nil

    var hideBottomBar:Bool = false {
        didSet {
            if oldValue != hideBottomBar {
                UIView.animate(withDuration: 0.25) {[weak self]in
                    self?.updateFrame()
                }
            }
        }
    }
    //MARK: - IBOutlet
    
    @IBOutlet weak var progressView: RingProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    public struct ViewModel {
        public let progress:Double
        public let title:String?
        public let desc:String?
        public init (progress:Double, title:String?, desc:String?) {
            self.progress = progress
            self.title = title
            self.desc = desc
        }
    }
    
    let disposeBag = DisposeBag()
    
    //MARK: - arrangeView
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        arrangeView()
    }
    
    func arrangeView() {
        guard let view = UINib(
                nibName: String(describing: NaruMusicPlayerMiniView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        alpha = 0
        playButton.rx.tap.bind { [unowned self](_) in            
            NaruAudioPlayer.shared.toggle()
            playButton.isSelected.toggle()
            NotificationCenter.default.post(name: .naruMusicPlayerMiniCotrollerMessage, object: "play")
        }.disposed(by: disposeBag)
        
        plusButton.rx.tap.bind { (_) in
            NotificationCenter.default.post(name: .naruMusicPlayerMiniCotrollerMessage, object: "plus")
        }.disposed(by: disposeBag)
        
        closeButton.rx.tap.bind { [unowned self](_) in
            NaruAudioPlayer.shared.stop()
            NaruAudioPlayer.shared.removeAllMusic()
            NotificationCenter.default.post(name: .naruMusicPlayerMiniCotrollerMessage, object: "close")
            alpha = 0
        }.disposed(by: disposeBag)
        func showup() {
            if alpha == 0 {
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.alpha = 1
                }
            }
        }
      
        NotificationCenter.default.addObserver(forName: .naruAudioPlayerStatusDidChange, object: nil, queue: nil) { [weak self](noti) in
            if let progress = noti.object as? Progress {
                let total = progress.totalUnitCount
                let complete = progress.completedUnitCount
                let progress = Double(complete) / Double(total)
                self?.progressView.progress = progress
                self?.titleLabel.text = "loading"
                self?.descLabel.text = "\(complete) / \(total)"
                showup()
            }
            if let data = noti.object as? NaruAudioPlayer.PlayTimeInfo {
                self?.playButton.isSelected = data.isPlaying
                self?.titleLabel.text = data.title
                self?.descLabel.text = "\(data.subTitle ?? "") · \(data.duration.formatted_ms_String ?? "")"
                self?.progressView.progress = Double(data.progress)
                showup()
            }
            if let tabbarHide = self?.superTabbarController?.tabBar.isHidden  {
                self?.hideBottomBar = tabbarHide
            }
        }
        
    }
    
    
    public func showPlayer(targetViewController:UIViewController) {
        superTabbarController = targetViewController.tabBarController
        var tvc = targetViewController
        if let vc = tvc.tabBarController {
            tvc = vc
        }
        tvc.view.addSubview(self)
        superViewController = tvc
        updateFrame()
    }
    
    
    func updateFrame() {
        var bottomHeight = superViewController?.view.safeAreaInsets.bottom ?? 0
        if let vc = superTabbarController {
            if hideBottomBar == false {
                bottomHeight =  vc.tabBar.frame.height
            }
        }

        autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        let newFrame = CGRect(x: 0, y: UIScreen.main.bounds.height - bottomHeight - 72 , width: UIScreen.main.bounds.width, height: 72)
        frame = newFrame
    }
    
}
