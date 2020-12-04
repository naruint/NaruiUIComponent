//
//  NaruVideoPlayerView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/12/04.
//

import Foundation
import AVKit
class NaruVideoPlayerView: UIView {
  
  var videoLayer: AVPlayerLayer!
  var player: AVPlayer? {
    didSet {
      videoLayer = AVPlayerLayer(player: self.player)
      videoLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
      self.layer.addSublayer(videoLayer)
    }
  }
  
  func updateVideoLayerFrame() {
    if let _ = videoLayer {
      videoLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.updateVideoLayerFrame()
  }
  
}
