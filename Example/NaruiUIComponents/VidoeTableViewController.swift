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
        videoController.targetViewController = self
        videoController.viewModel = NaruVideoControllerView.ViewModel(title: "자전거 타자", startDescTime: 10, endDescTime: 20, url: URL(string: "https://www.dropbox.com/s/42o0drn3bazca7p/video.mp4?dl=1")!, thumbnailURL: nil)
        videoController.isBackButtonHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoController.openVideo()
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
