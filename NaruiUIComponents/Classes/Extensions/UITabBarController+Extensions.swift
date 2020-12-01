//
//  UITabBarController+Extensions.swift
//  NaruiUIComponents
//
//  Created by Changyul Seo on 2020/11/28.
//

import Foundation
public extension UITabBarController {
    func makeMusicPlayerView() {
        guard let top = tabBar.superview else {
            return
        }
        let tag = 18372
        let view = top.viewWithTag(tag) as? NaruMusicPlayerMiniView ?? NaruMusicPlayerMiniView()
        if view.tag != tag {
            top.addSubview(view)
            view.tag = tag
        }
        
        view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        let bottomHeight:CGFloat =  tabBar.isHidden ? top.safeAreaInsets.bottom : tabBar.frame.height
        
        let newFrame = CGRect(x: 0, y: UIScreen.main.bounds.height - bottomHeight - 72 , width: UIScreen.main.bounds.width, height: 72)
        view.frame = newFrame
        
    }
}
