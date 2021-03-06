//
//  NaruVideoPlayer.swift
//  UITest
//
//  Created by Changyeol Seo on 2020/10/16.
//
import Foundation
import AVKit
fileprivate var isConnectInternet:Bool {
    guard let url = URL(string: "https://www.google.com") else {
        return false
    }
    return (try? Data(contentsOf: url)) != nil
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil && isConnectInternet
    }
}

public class NaruVideoPlayer {
    public struct VideoStatus {
        /** 지금 제생 시간 (초)*/
        public let time:Double
        /** 전체 제생 시간(초)*/
        public let duration:Double
        /** 버퍼링 된 시간(초)*/
        public let bufferedTimes:[CMTimeRange]
        
        public let playerItem:AVPlayerItem
        
        public init(time:Double, duration:Double, bufferedTimes:[CMTimeRange], playerItem:AVPlayerItem) {
            self.time = time
            self.duration = duration
            self.bufferedTimes = bufferedTimes
            self.playerItem = playerItem
        }
        
        public var progress:CGFloat {
            if duration == 0.0 || duration.isNaN || time.isNaN {
                return 0.0
            }
            let result = CGFloat(time / duration)
            return result < 0 ? 0 : result
        }
        
        public var bufferedStartProgress:CGFloat {
            if duration == 0.0 || duration.isNaN {
                return 0.0
            }
            var result:[CGFloat] = []
            for time in bufferedTimes {
                result.append(CGFloat(time.start.seconds / duration))
            }
            return result.last ?? 0.0
        }
        
        public var bufferedEndProgress:CGFloat {
            if duration == 0.0 || duration.isNaN {
                return 0.0
            }
            var result:[CGFloat] = []
            for time in bufferedTimes {
                result.append(CGFloat(time.end.seconds / duration))
            }
            return result.last ?? 0.0
        }
    }
    
    static let shared = NaruVideoPlayer()
    public var url:URL? = nil
    var player:AVPlayer? = nil
//    var playerLayer:AVPlayerLayer? = nil
    
    let timer = NaruTimmer()
    var isPlaying:Bool {
        return player?.isPlaying ?? false
    }
    
    init() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemTimeJumped, object: nil, queue: nil) { [weak self](noti) in
            // print("AVPlayerItemTimeJumped : \(noti)")
            
            guard let s = self, let item = noti.object as? AVPlayerItem else {
                return
            }
            
            if s.player?.isPlaying == true && item.duration.seconds > 0 {
                // print("timer start")
                s.timer.start()
            } else {
                // print("timer stop")
                s.timer.stop()
            }
            if item.currentTime().seconds == item.duration.seconds {
                s.timer.stop()
            }
        }
  
    }
    
    public func playVideo(webUrl:String, containerView: UIView)->AVPlayerLayer? {
        guard let url = URL(string: webUrl) else {
            return nil
        }
        self.url = url
        let asset = AVAsset(url: url)
        
        let playerItem = AVPlayerItem(asset: asset)
       
        let player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame.size = containerView.frame.size
        containerView.layer.insertSublayer(playerLayer, at: 0)
        self.player = player
        

        return playerLayer
    }
    
    public func makePlayerLayer(containerView:UIView)->AVPlayerLayer? {
        guard let player = self.player else {
            return nil
        }
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame.size = containerView.frame.size
        containerView.layer.insertSublayer(playerLayer, at: 0)
        return playerLayer
    }
    
    
    
    public func pause() {
        player?.pause()
    }
    
    public func play() {
        player?.play()
    }
    
    public func stop() {
        let time = CMTime(value: CMTimeValue(0), timescale: 1000)
        player?.seek(to: time)
        player?.pause()
    }
    
    public func rewindVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }

    public func forwardVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    public func progress(progress:@escaping(_ proress:VideoStatus)->Void) {
        guard let currentItem = player?.currentItem
        else {
            return
        }
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(500), timescale: 500), queue: nil, using: { [weak self](time) in
            progress(VideoStatus(
                time:currentItem.currentTime().seconds,
                duration: currentItem.duration.seconds,
                bufferedTimes: currentItem.loadedTimeRanges as! [CMTimeRange],
                playerItem: currentItem
            ))
            
            if currentItem.currentTime().seconds == currentItem.duration.seconds {
                self?.timer.stop()
            }
        })
        
    }
    
    public func seek(progress:Float) {
        guard let totalTime = player?.currentItem?.duration.seconds else {
            return
        }
        
        let value = totalTime * Double(progress)
        if value.isNaN {
            return
        }
        // print("seek to time \(value) progress : \(progress)")
        player?.seek(to: CMTime(value: CMTimeValue(value * 1000), timescale: 1000))
    }
    
    public func seek(time:TimeInterval) {
//        guard let item = player?.currentItem else {
//            return
//        }
//        player?.seek(to: CMTime(seconds: time, preferredTimescale: item.currentTime().timescale))
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
    }
}
