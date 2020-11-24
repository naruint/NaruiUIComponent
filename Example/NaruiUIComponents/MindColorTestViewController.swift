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
    @IBOutlet var ringProgressView: [NaruRingProgressView]!
    let ringDatas:[NaruRingProgressView.ViewModel] = [
        NaruRingProgressView.ViewModel(secondLabelText: "감자", progress: 0.1, forgroundColor: .yellow, ringBackgrouncColor: .gray),
        NaruRingProgressView.ViewModel(secondLabelText: "고구마", progress: 0.2, forgroundColor: .orange, ringBackgrouncColor: .gray),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index,rview) in ringProgressView.enumerated() {
            rview.viewModel = ringDatas[index]
        }
        
    }
}
