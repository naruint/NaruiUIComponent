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
        
        let view = top.subviews.filter { (view) -> Bool in
            return view.isKind(of: NaruMusicPlayerMiniView.self) == true
        }.first ?? NaruMusicPlayerMiniView()
        
        if view.superview != top {
            top.addSubview(view)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: top.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: top.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: top.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
