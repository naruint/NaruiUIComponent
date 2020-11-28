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
    static let naruMusicPlayerMiniDataUpdate = Notification.Name("naruMusicPlayerMiniDataUpdate_observer")
    static let naruMusicPlayerMiniCotrollerMessage = Notification.Name("naruMusicPlayerMiniCotrollerMessage_observer")
}

@IBDesignable
public class NaruMusicPlayerMiniView: UIView {
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
        
        playButton.rx.tap.bind { [unowned self](_) in
            playButton.isSelected.toggle()
            if playButton.isSelected {
                NotificationCenter.default.post(name: .naruMusicPlayerMiniCotrollerMessage, object: "play")
            }
            else {
                NotificationCenter.default.post(name: .naruMusicPlayerMiniCotrollerMessage, object: "pause")
            }
        }.disposed(by: disposeBag)
        
        plusButton.rx.tap.bind { (_) in
            NotificationCenter.default.post(name: .naruMusicPlayerMiniCotrollerMessage, object: "plus")
        }.disposed(by: disposeBag)
        
        closeButton.rx.tap.bind { [unowned self](_) in
            NotificationCenter.default.post(name: .naruMusicPlayerMiniCotrollerMessage, object: "close")
            removeFromSuperview()
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(forName: .naruMusicPlayerMiniDataUpdate, object: nil, queue: nil) { [weak self](noti) in
            if let data = noti.object as? ViewModel {
                self?.titleLabel.text = data.title
                self?.descLabel.text = data.desc
                self?.progressView.progress = data.progress
                self?.titleLabel.isHidden = data.title == nil
                self?.descLabel.isHidden = data.desc == nil
            }
        }
        
    }
    
}
