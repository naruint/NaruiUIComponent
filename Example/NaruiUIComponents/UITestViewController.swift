//
//  UITestViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyul Seo on 2020/11/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NaruiUIComponents
class UITestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .naruMusicPlayerMiniDataUpdate, object: NaruMusicPlayerMiniView.ViewModel(progress: Double.random(in: 0.0...1.0), title: "우리는 하나", desc: "잘 살아 보세"))

        tabBarController?.makeMusicPlayerView()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
