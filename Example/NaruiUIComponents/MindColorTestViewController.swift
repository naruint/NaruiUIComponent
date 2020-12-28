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
    let tagFiltterView = NaruBottomSheetTagFilterViewController.viewController

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
        
            if let result = noti.object as? [String:[String]] {
                for list in result {
                    if list.key == "상태" {
                        self?.tagCollectionView.tags = list.value
                    }
                }
            }
        }
        makeBottomSheet()
                
    }
    
    @objc func onTouchUPRightBarButton(_ sender:UIBarButtonItem) {
        tagFiltterView.setTags(selectedTags: ["상태":tagCollectionView.tags])
        tagFiltterView.show(target: self)
    }
    
    func makeBottomSheet() {
        tagFiltterView.setFilterSet(
            set: [
                NaruBottomSheetTagFilterViewController.Model.FilterSet(
                    title: "상태",
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
    }
}
