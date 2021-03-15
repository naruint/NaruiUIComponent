//
//  NaruAudioPlayer.swift
//  UITest
//
//  Created by Changyeol Seo on 2020/10/16.
//

import Foundation
import AVKit
import MediaPlayer
import Alamofire
public extension Notification.Name {
    static let naruAudioPlayerStatusDidChange = Notification.Name("naruAudioPlayerStatusDidChange_observer")
    /** 오디오 청취 시간 측정값을 리턴하는 notification */
    static let naruAudioPlayFinished = Notification.Name("naruAudioWatchFinished_observer")
    /** 오디오 제생 시작하는 시점 알려주는 노티*/
    static let naruAudioPlayDidStart = Notification.Name("naruAudioPlayDidStart_observer")
}
/**
 insertMusic(url:URL?, isFirstTrack:Bool) // 음원 넣기
 removeMusic(url:URL) // 음원 뺴기
 setupNowPlaying(title:String, artwrok:UIImage) // 제생하기 
 */
public class NaruAudioPlayer {
    public struct TimeResult {
        public let time:TimeInterval
        public let seqNo:String
        public let title:String
        public let isComplete:Bool
    }
    
   
    
    public struct PlayTimeInfo {
        public let title:String?
        public let subTitle:String?
        public let currentTime:TimeInterval
        public let duration:TimeInterval
        public let isPlaying:Bool
        public var progress:Float {
            return Float(currentTime / duration)
        }
        public var currentTimeStringValue:String {
            "\(Int(currentTime))"
        }
        public var durationStringValue:String {
            "\(Int(duration))"
        }
        public init(title:String?, subTitle:String?, currentTime:TimeInterval, duration:TimeInterval, isPlaying:Bool) {
            self.title = title
            self.subTitle = subTitle
            self.currentTime = currentTime
            self.duration = duration
            self.isPlaying = isPlaying
        }
    }
    public var isAutoCloseWhenPlayOnce:Bool = false
    
    public var isLoopPlayForever:Bool = false {
        didSet {
            setLoop()
        }
    }
    
    func setLoop() {
        switch players.count {
        case 0:
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        case 1:
            firstPlayer?.numberOfLoops = isLoopPlayForever ? -1 : 0
        case 2:
            firstPlayer?.numberOfLoops = isLoopPlayForever ? -1 : 0
            secondPlayer?.numberOfLoops = -1
        default:
            break
        }
    }
    
    public static let shared = NaruAudioPlayer()
    public var musicUrls:[URL] {
        get {
            var result:[URL] = []
            for url in [firstMusicURL,secondMusicURL] {
                if let url = url {
                    result.append(url)
                }
            }
            return result
        }
    }
    var firstMusicURL:URL? = nil
    var secondMusicURL:URL? = nil
    
    
    var playerItems:[AVPlayerItem]  {
        var result:[AVPlayerItem] = []
        for url in musicUrls {
            result.append(AVPlayerItem(url: url))
        }
        return result
    }
    
    var players:[URL:AVAudioPlayer] = [:] {
        didSet {
            setLoop()
        }
    }
    /** 첫번째 플레이어를 리턴함.*/
    public var firstPlayer:AVAudioPlayer? {
        if let url = musicUrls.first {
            return players[url]
        }
        return nil
    }
    /** 두번째 플레이어 리턴함. (믹스일 제생일 경우 BGM부분)*/
    public var secondPlayer:AVAudioPlayer? {
        if musicUrls.count == 2 {
            if let url = musicUrls.last {
                return players[url]
            }
        }
        return nil
    }

    
    var title:String? = nil
    var subTitle:String? = nil
    var artworkImageURL:URL? = nil
    var seqNo:String = ""
    

    public init() {
       
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            if musicUrls.count == 0 {
                return .noActionableNowPlayingItem
            }
            play{
                
            }
            return .success
        }
        commandCenter.pauseCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            pause()
            return .success
        }
        commandCenter.stopCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            stop()
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .noActionableNowPlayingItem
        }
        
        commandCenter.nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .noActionableNowPlayingItem
        }
                
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self](event) -> MPRemoteCommandHandlerStatus in
            // print(event)
            if let p = firstPlayer {
                p.currentTime = (event as? MPChangePlaybackPositionCommandEvent)?.positionTime ?? 0
                return .success
            }
            return .noActionableNowPlayingItem
        }
        
        NotificationCenter.default.addObserver(forName: .naruAudioPlayerStatusDidChange, object: nil, queue: nil) {[weak self] (noti) in
            if let p = self?.firstPlayer {
                if self?.isAutoCloseWhenPlayOnce == true {
                    if p.currentTime == p.duration {
                        self?.removeAllMusic()
                    }
                }
            }
        }
    }
    
    public func insertMusic(url:URL?, isFirstTrack:Bool) {
        if let url = url {
            if isFirstTrack {
                if let furl = firstMusicURL {
                    removeMusic(url: furl)
                }
                firstMusicURL = url
            } else {
                if let surl = secondMusicURL {
                    removeMusic(url: surl)
                }
                secondMusicURL = url
            }
            NaruTimmer.audioTimer.reset()
        }
    }
    
    public func removeMusic(url:URL?) {
        var isComplete = false
        if let p = firstPlayer {
            if p.currentTime / p.duration > 0.98 {
                isComplete = true
            }
        }
        if let url = url, let index = musicUrls.firstIndex(where: { (u) -> Bool in
            return u == url
        }) {
            if let p = players[url] {
                p.stop()
                players[url] = nil
                switch index {
                case 0:
                    firstMusicURL = nil
                default:
                    secondMusicURL = nil
                }
            }
        }
        if players.count == 0 {
            NaruTimmer.audioTimer.stop()
            NotificationCenter.default.post(
                name: .naruAudioPlayFinished,
                object: TimeResult(time: NaruTimmer.audioTimer.timeResult, seqNo: seqNo, title: title ?? "",isComplete: isComplete)
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                NaruTimmer.audioTimer.reset()
            }
        }
    }
    
    public func removeAllMusic() {
        firstMusicURL = nil
        secondMusicURL = nil
        var isComplete = false

        if let player = firstPlayer {
            print("time : \(player.currentTime) / \(player.duration) : \(player.currentTime / player.duration)")
            if player.currentTime / player.duration > 0.98 {
                isComplete = true
            }
        }
        for player in players.values {
            print("time : \(player.currentTime) / \(player.duration) : \(player.currentTime / player.duration)")
            if player.currentTime / player.duration > 0.98 {
                isComplete = true
            }
            player.stop()
        }
        players.removeAll()
        NaruTimmer.audioTimer.stop()
        if NaruTimmer.audioTimer.timeResult > 0.01 {
            NotificationCenter.default.post(name: .naruAudioPlayFinished,
                                            object: TimeResult(
                                                time: NaruTimmer.audioTimer.timeResult,
                                                seqNo: seqNo,
                                                title: title ?? "",
                                                isComplete: isComplete
                                            ))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            NaruTimmer.audioTimer.reset()
        }
    }
    
    public var isPlaying:Bool {
        for player in players.values {
            if player.isPlaying {
                return true
            }
        }
        return false
    }
    
    public func toggle() {
        if isPlaying {
            pause()
        } else {
            play{
                
            }
        }
    }
    
    public func play(title:String,subTitle:String, artworkImageURL:URL?, artworkImagePlaceHolder:UIImage ,seqNo:String, isAutoClose:Bool = false) {
        self.seqNo = seqNo
        self.isAutoCloseWhenPlayOnce = isAutoClose
        
        play { [unowned self] in
            setupNowPlaying(title: title, subTitle: subTitle, artworkImageURL: artworkImageURL, artworkImagePlaceHolder: artworkImagePlaceHolder)
        }
    }
    
    func play(prepareAudio:@escaping()->Void) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay])
            // print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            // print("Session is Active")
        } catch {
            // print(error)
        }
        
        // print("audio play : \(players))")
        func playMusic() {
            for player in players.values {
                player.play()
            }
            NotificationCenter.default.post(name: .naruAudioPlayDidStart, object: nil)
            NaruTimmer.audioTimer.start()
        }
        var needPrepareURL:[URL] = []
        for url in musicUrls {
            if players[url] == nil {
                needPrepareURL.append(url)
            }
        }
        if needPrepareURL.count == 0 {
            playMusic()
            return
        }
        for url in needPrepareURL {
            if url.isFileURL {
                if let player = try? AVAudioPlayer(contentsOf: url) {
                    player.prepareToPlay()
                    players[url] = player
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {[unowned self] in
                        playMusic()
                        updateTime()
                        prepareAudio()
                        self.timmerSwitch = true
                    }
                }
            } else {
                NaruFileDownloadManager().download(key:seqNo,url: url) {[unowned self] (fileUrl) in
                    if let fileUrl = fileUrl {
                        if let player = try? AVAudioPlayer(contentsOf: fileUrl) {
                            player.prepareToPlay()
                            players[url] = player
                            playMusic()
                            prepareAudio()
                            self.timmerSwitch = true
                        }
                    }
                }
            }
        }
    }
    
    public func stop() {
        pause()
        players.removeAll()
        NaruTimmer.audioTimer.stop()
    }
    
    public func pause() {
        for player in players.values {
            player.stop()
        }
        NaruTimmer.audioTimer.stop()
    }
   
    public func seek(time:TimeInterval) {
        firstPlayer?.currentTime = time
    }
    
    func setupNowPlaying(title:String,subTitle:String, artworkImageURL:URL?, artworkImagePlaceHolder:UIImage) {
        if let p = self.firstPlayer {
            NowPlayUtill.setupNowPlaying(title: title,
                                         subTitle: subTitle,
                                         artworkImageURL: artworkImageURL,
                                         artworkImagePlaceHolder: artworkImagePlaceHolder,
                                         currentTime: p.currentTime,
                                         duration: p.duration,
                                         rate: p.rate)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {[weak self]in
                self?.setupNowPlaying(title: title, subTitle: subTitle, artworkImageURL: artworkImageURL, artworkImagePlaceHolder: artworkImagePlaceHolder)
            }
        }
        
        
    }
    
    var timmerSwitch = false {
        didSet {
            if timmerSwitch == true && oldValue == false {
                updateTime()
            }
        }
    }
    
    func updateTime() {
        guard let player = self.firstPlayer else {
            NaruAudioPlayer.shared.timmerSwitch = false
            return
        }
//        let value:Float = Float(player.currentTime / player.duration)
//        // print("updateTime : \( player.currentTime) \(player.duration) \(value)")
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            self?.updateTime()
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        
        DispatchQueue.main.async {[weak self] in
            guard let s = self else {
                return
            }
            if s.players.count == 0 {
                return
            }
            if s.firstPlayer?.isPlaying == false {
                s.secondPlayer?.stop()
                s.timmerSwitch = false
            }
            if floor(player.currentTime) == ceil(player.duration) {
                NotificationCenter.default.post(
                    name: .naruAudioPlayerStatusDidChange,
                    object: PlayTimeInfo(
                        title: s.title,
                        subTitle: s.subTitle,
                        currentTime: player.duration,
                        duration: player.duration,
                        isPlaying: player.isPlaying)
                )
            } else {
                NotificationCenter.default.post(
                    name: .naruAudioPlayerStatusDidChange,
                    object: PlayTimeInfo(
                        title: s.title,
                        subTitle: s.subTitle,
                        currentTime: player.currentTime,
                        duration: player.duration,
                        isPlaying: player.isPlaying)
                )
            }
            
        }
    }
}

