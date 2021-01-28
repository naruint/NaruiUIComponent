//
//  VideoTableViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyeol Seo on 2020/12/04.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NaruiUIComponents

class VideoTableViewController: UITableViewController {

    @IBOutlet weak var videoController: NaruVideoControllerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = NaruVideoControllerView.ViewModel(
            id: "002",
            midaDvcd: "1",
            title: "자전거 타자",
            currentTime: 20,
            duration:300,
            startDescTime: 10,
            endDescTime: 70,
            url: URL(string: "https://www.dropbox.com/s/0sc26e8shaukm48/Unicycle%20%EB%A1%9C%EB%9D%BC%ED%83%80%EA%B8%B0.mp4?dl=1")!, thumbnailURL: URL(string: "https://newsimg.hankookilbo.com/cms/articlerelease/2019/04/29/201904291390027161_3.jpg"))
        
        videoController.openVideo(viewModel: viewModel)

//        videoController.targetViewController = self
////        videoController.viewModel = NaruVideoControllerView.ViewModel(title: "자전거 타자", startDescTime: 10, endDescTime: 20, url: URL(string: "https://player.vimeo.com/external/321159666.hd.mp4?s=772ae60145f3fac0b667dc316fa21105e6062358&profile_id=175")!, thumbnailURL: nil)
//        videoController.isBackButtonHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        videoController.openVideo()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
   
}
