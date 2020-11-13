//
//  NaruVideoPlayer.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/13.
//

import Foundation
import AVKit

public class NaruVideoPlayer {
    public init() {
        
    }
    
    public var playerLayer:AVPlayerLayer? = nil
    var player:AVQueuePlayer? = nil
    var playerLooper:AVPlayerLooper? = nil

    /** 웹URL 제생*/
    public func playVideo(webUrl:String, targetView:UIView?, isLoop:Bool) {
        guard let url = URL(string: webUrl) else {
            return
        }
        playVideo(url: url, targetView: targetView, isLoop: isLoop)
    }

    /** 첨부파일 제생*/
    public func playVideo(fileName:String, fileExt:String, targetView:UIView?, isLoop:Bool)->Bool {
        guard let videoURL = Bundle.main.url(forResource: fileName, withExtension: fileExt)  else {
            return false
        }
        playVideo(url: videoURL, targetView: targetView, isLoop: isLoop)
        return true

    }
    
    public func playVideo(url:URL, targetView:UIView?, isLoop:Bool) {
        let tv = targetView ?? UIApplication.shared.keyWindow?.rootViewController?.view
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
       
        let player = AVQueuePlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame.size = tv?.bounds.size ?? .zero
        self.playerLayer = playerLayer
        playerLayer.zPosition = -1
        tv?.layer.insertSublayer(playerLayer, at: 0)
        self.player = player
        if isLoop {
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        }
        else {
            playerLooper = nil
        }
        player.prepareForInterfaceBuilder()
        player.play()
    }
}
