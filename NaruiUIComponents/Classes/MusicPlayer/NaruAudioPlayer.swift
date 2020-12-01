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
extension Notification.Name {
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
            play()
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
    
    public func removeMusic(url:URL) {
        if let index = musicUrls.firstIndex(where: { (u) -> Bool in
            return u == url
        }) {
            musicUrls.remove(at: index)
            players[url]?.stop()
            players[url] = nil
        }
    }
    
    public func removeAllMusic() {
        musicUrls.removeAll()
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
            play()
        }
    }
    
    public func play() {
        print("audio play : \(players))")
        func playMusic() {
            for player in players.values {
                player.play()
            }
        }
        if players.values.count > 0 {
            playMusic()
            return
        }
        for url in musicUrls {
            if url.isFileURL {
                if let player = try? AVAudioPlayer(contentsOf: url) {
                    player.prepareToPlay()
                    players[url] = player
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {[unowned self] in
                        playMusic()
                        updateTime()
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
                    if let url = response.fileURL {
                        print(url.absoluteString)
                        if let player = try? AVAudioPlayer(contentsOf: url) {
                            player.prepareToPlay()
                            players[url] = player
                            playMusic()
                            updateTime()
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
   
    public func setupNowPlaying(title:String,subTitle:String, artworkImageURL:URL?) {
        func setNowPlay(artwork:UIImage) {
            var nowPlayingInfo:[String:Any] = [:]
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size, requestHandler: { (size) -> UIImage in
                return artwork
            })
            if let item = playerItems.first {
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = item.currentTime().seconds
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = item.duration.seconds
            }
            if let player = players.first?.value {
                nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
            }
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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

    
    func updateTime() {
        guard let player = players.first?.value else {
            return
        }
        let value:Float = Float(player.currentTime / player.duration)
        print("updateTime : \( player.currentTime) \(player.duration) \(value)")
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.updateTime()
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        
        DispatchQueue.main.async {[unowned self] in
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

