//
//  NaruLandScapeVideoViewController.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/12/04.
//

import Foundation
import UIKit
import AVKit
public protocol NaruLandscapeVideoViewControllerDelegate:class {
    func naruLandscapeVideoViewControllerDidDismiss(seqNum:String?)
}

public class NaruLandscapeVideoViewController: UIViewController {
    public weak var delegate:NaruLandscapeVideoViewControllerDelegate? = nil
    public override var prefersStatusBarHidden: Bool { true }
    public override var prefersHomeIndicatorAutoHidden: Bool { true }
            
    public var isLandscapeOnly:Bool = true
    public var isAutoDismissWhenFinish:Bool = false
    public var viewModel:NaruVideoControllerView.ViewModel? {
        set {
            playerControllerView.viewModel = newValue
            playerControllerView.titleLabel.text = newValue?.title
        }
        get {
            playerControllerView.viewModel
        }
    }
    
    public var avPlayer:AVPlayer? {
        set {
            playerControllerView.avPlayer = newValue
            
        }
        get {
            playerControllerView.avPlayer
        }
    }
    
    deinit {
        // print("deinit NaruLandscapeVideoViewController")
        playerControllerView.avPlayer = nil
    }
    
    public let playerControllerView = NaruVideoControllerView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        
        addPlayerController()
        view.backgroundColor = .black
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen

        NaruOrientationHelper.shared.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        playerControllerView.fullScreenController = self
        NotificationCenter.default.addObserver(forName: .naruVideoWatchFinished, object: nil, queue: nil) { [weak self](noti) in
            guard let info = noti.object as? NaruVideoControllerView.ResultModel else {
                return
            }
            if info.isWatchFinish && self?.isAutoDismissWhenFinish == true {
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
        
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerControllerView.layer.sublayers?.first?.frame = playerControllerView.layer.frame
        playerControllerView.updatePlayBtn()
        playerControllerView.updateSlider()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerControllerView.addObserver()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let pl = playerControllerView.layer.sublayers?.first as? AVPlayerLayer {
            pl.frame = view.frame
        }
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        NaruOrientationHelper.shared.lockOrientation(.portrait, andRotateTo: .portrait)
        super.dismiss(animated: flag) {
            self.delegate?.naruLandscapeVideoViewControllerDidDismiss(seqNum: self.viewModel?.id)
            completion?()
        }
    }
    
    private func addPlayerController() {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // swap width & height becox the mainScreen is still in portrait
        playerControllerView.frame = CGRect(x: 0, y: 0, width: screenHeight, height: screenWidth)
        
        playerControllerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerControllerView)
        
        let top = NSLayoutConstraint(item: playerControllerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: playerControllerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: playerControllerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: playerControllerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        view.addConstraints([top, bottom, leading, trailing])
    }
    
}
