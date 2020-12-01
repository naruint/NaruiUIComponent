//
//  MindColorTestViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyeol Seo on 2020/11/24.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import NaruiUIComponents

class MindColorTestViewController : UIViewController {
    
    @IBOutlet weak var tagCollectionView: NaruTagCollectionView!
    @IBOutlet var ringProgressView: [NaruRingProgressView]!
    let ringDatas:[NaruRingProgressView.ViewModel] = [
        NaruRingProgressView.ViewModel(secondLabelText: "감자", progress: 0.1, forgroundColor: .yellow, ringBackgrouncColor: UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.1)),
        NaruRingProgressView.ViewModel(secondLabelText: "고구마", progress: 0.2, forgroundColor: .orange, ringBackgrouncColor: UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 0.1))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index,rview) in ringProgressView.enumerated() {
            rview.viewModel = ringDatas[index]
        }
        tagCollectionView.tags = ["바보","강아지","고양이","태권브이","고구마","감자"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "tag", style: .plain, target: self, action: #selector(self.onTouchUPRightBarButton(_:)))
        
        NotificationCenter.default.addObserver(forName: .naruBottomSheetTagFilterSelectionDidChange, object: nil, queue: nil) {[weak self] (noti) in
        
            if let tags = noti.object as? [String],
               let title = noti.userInfo?["title"] as? String {
                print("tags: \(tags) title : \(title)")
                if title == "태그" {
                    self?.tagCollectionView.tags = tags
                }
            }
        }
        NaruAudioPlayer.shared.insertMusic(url: URL(string: "https://www.dropbox.com/s/6lrki8rfyx0hi1r/effect1.mp3?dl=1"), isFirstTrack: false)
        NaruAudioPlayer.shared.insertMusic(url: URL(string: "https://www.dropbox.com/s/jryrixqfe8zupn5/music4.mp3?dl=1"), isFirstTrack: true)
        NaruAudioPlayer.shared.setupNowPlaying(title: "test", subTitle: "산들바람 솔솔", artworkImageURL: URL(string: "https://i.pinimg.com/originals/34/6e/df/346edf41cf7de5ba8a37d34a4771a4f0.jpg"))
        NaruAudioPlayer.shared.play()
    }
    
    @objc func onTouchUPRightBarButton(_ sender:UIBarButtonItem) {
        let vc = NaruBottomSheetTagFilterViewController.viewController
        vc.setFilterSet(
            set: [
                NaruBottomSheetTagFilterViewController.Model.FilterSet(
                    title: "태그",
                    isMultipleSelect: true,
                    tags: [
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "쌀", prefix: "#"),
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "보리", prefix: "#"),
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "귀리", prefix: "#"),
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "귤", prefix: "#"),
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "지리산", prefix: "#"),
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "토종닭", prefix: "#"),
                    ]),
                NaruBottomSheetTagFilterViewController.Model.FilterSet(
                    title: "클래스",
                    isMultipleSelect: false,
                    tags: [
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "밥", prefix: nil),
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "국", prefix: nil),
                        NaruBottomSheetTagFilterViewController.Model.Tag(text: "고기", prefix: nil),
                    ]),
            ]
        )
        vc.showBottomSheet(
            targetViewController: self ,
            selectedTags: ["상태":tagCollectionView.tags])
    }
}
