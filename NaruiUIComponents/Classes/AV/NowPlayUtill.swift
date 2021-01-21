//
//  NowPlayUtill.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2021/01/18.
//

import Foundation
import MediaPlayer

public struct NowPlayUtill {
    public static func setupNowPlaying(title:String,subTitle:String, artworkImageURL:URL?, artworkImagePlaceHolder:UIImage , currentTime:TimeInterval, duration:TimeInterval, rate:Float) {
        func setNowPlay(artwork:UIImage) {
            var nowPlayingInfo:[String:Any] = [:]
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size, requestHandler: { (size) -> UIImage in
                return artwork
            })
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rate
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }

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
            setNowPlay(artwork: artworkImagePlaceHolder)
        }
    }
}
