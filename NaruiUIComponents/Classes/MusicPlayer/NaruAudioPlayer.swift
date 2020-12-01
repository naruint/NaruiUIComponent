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
}
/**
 insertMusic(url:URL?, isFirstTrack:Bool) // 음원 넣기
 removeMusic(url:URL) // 음원 뺴기
 setupNowPlaying(title:String, artwrok:UIImage) // 제생하기 
 */
public class NaruAudioPlayer {
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
    
    public static let shared = NaruAudioPlayer()
    public var musicUrls:[URL] = []
    
    var playerItems:[AVPlayerItem]  {
        var result:[AVPlayerItem] = []
        for url in musicUrls {
            result.append(AVPlayerItem(url: url))
        }
        return result
    }
    
    var players:[URL:AVAudioPlayer] = [:]
    var player:AVAudioPlayer? {
        if let url = musicUrls.first {
            return players[url]
        }
        return nil
    }
    
    var title:String? = nil
    var subTitle:String? = nil
    var artworkImageURL:URL? = nil
    
    public init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
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
            print(event)
            if let p = player {
                p.currentTime = (event as? MPChangePlaybackPositionCommandEvent)?.positionTime ?? 0
                return .success
            }
            return .noActionableNowPlayingItem
        }
        
        

    }
    
    public func insertMusic(url:URL?, isFirstTrack:Bool) {
        if let url = url {
            if isFirstTrack {
                musicUrls.insert(url, at: 0)
            } else {
                musicUrls.append(url)
            }
        }
    }
    
    public func removeMusic(url:URL?) {
        if let url = url, let index = musicUrls.firstIndex(where: { (u) -> Bool in
            return u == url
        }) {
            players[url]?.stop()
            players[url] = nil
            musicUrls.remove(at: index)
        }
    }
    
    public func removeAllMusic() {
        musicUrls.removeAll()
        for player in players.values {
            player.stop()
        }
        players.removeAll()
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
    
    public func play(title:String,subTitle:String, artworkImageURL:URL?) {
        play { [unowned self] in
            setupNowPlaying(title: title, subTitle: subTitle, artworkImageURL: artworkImageURL)
        }
    }
    
    public func play(prepareAudio:@escaping()->Void) {
        print("audio play : \(players))")
        func playMusic() {
            for player in players.values {
                player.play()
            }
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
                AF.download(url)
                    .downloadProgress(closure: { (progress) in
                        NotificationCenter.default.post(
                            name: .naruAudioPlayerStatusDidChange,
                            object: progress)
                    })
                    .responseURL { [unowned self] (response) in
                    if let fileUrl = response.fileURL {
                        print(fileUrl.absoluteString)
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
    }
    
    public func pause() {
        for player in players.values {
            player.stop()
        }
    }
   
    func setupNowPlaying(title:String,subTitle:String, artworkImageURL:URL?) {
        func setNowPlay(artwork:UIImage) {
            var nowPlayingInfo:[String:Any] = [:]
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size, requestHandler: { (size) -> UIImage in
                return artwork
            })
            if let p = self.player {
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = p.currentTime
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = p.duration
                nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = p.rate
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    setNowPlay(artwork: artwork)
                }
            }
        }

        
        self.title = title
        self.subTitle = subTitle
        self.artworkImageURL = artworkImageURL
    
        if let url = artworkImageURL {
            let imageView = UIImageView()
            imageView.kf.setImage(with: url, completionHandler:  { (result) in
                if let image = imageView.image {
                    setNowPlay(artwork: image)
                } else {
                    setNowPlay(artwork: UIColor.red.circleImage(diameter: 100, innerColor: UIColor.white, innerDiameter: 50))
                }
            })
            
        } else {
            setNowPlay(artwork: UIColor.red.circleImage(diameter: 100, innerColor: UIColor.white, innerDiameter: 50))
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
        guard let player = players.first?.value else {
            timmerSwitch = false
            return
        }
        let value:Float = Float(player.currentTime / player.duration)
        print("updateTime : \( player.currentTime) \(player.duration) \(value)")
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            self?.updateTime()
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        
        DispatchQueue.main.async {[unowned self] in
            if players.count == 0 {
                return
            }
            NotificationCenter.default.post(
                name: .naruAudioPlayerStatusDidChange,
                object: PlayTimeInfo(
                    title: title,
                    subTitle: subTitle,
                    currentTime: player.currentTime,
                    duration: player.duration,
                    isPlaying: player.isPlaying)
            )
        }
    }
}

