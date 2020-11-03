//
//  GraphTopTestTableViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyeol Seo on 2020/11/02.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NaruiUIComponents

class GraphTopTestTableViewController: UITableViewController {

    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet weak var graphView: NaruGraphView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let json = "{\"values\" : [0.4,0.0,0.3,1.0,0.1,1.0,0.7,0.8]}"
        if let data = NaruGraphView.ViewModel.makeModel(string: json) {
            graphView.data = data
        }
        headerBgView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.headerBgView.alpha = 1
        }
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
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y < -200 {
            headerBgView.isHidden = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        let y = scrollView.contentOffset.y
        let alpha = (y + 200)/100
        headerBgView.alpha = alpha
    }

}
