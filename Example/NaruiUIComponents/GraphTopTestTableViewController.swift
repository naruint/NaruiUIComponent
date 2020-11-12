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
//    let value:Float
//    let dayOfTheWeek:String
//    let day:Int
    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet weak var graphView: NaruGraphView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let json = """
{ "values" : [
    {
    "value":0.4,
    "date":{"year":2020,"month":10,"day":20}
    },
    {
    "value":1.0,
    "date":{"year":2020,"month":10,"day":21}
    },
    {
    "value":0.3,
    "date":{"year":2020,"month":10,"day":22}
    },
    {
    "value":0.0,
    "date":{"year":2020,"month":10,"day":23}
    },
    {
    "value":1.0,
    "date":{"year":2020,"month":10,"day":24}
    },
    {
    "value":0.7,
    "date":{"year":2020,"month":10,"day":25}
    },
    {
    "value":0.1,
    "date":{"year":2020,"month":10,"day":26}
    }
]}
"""
        if let data = NaruGraphView.ViewModel.makeModel(string: json) {
            graphView.data = data
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(scrollView.contentOffset.y)
//        if scrollView.contentOffset.y < -200 {
//            headerBgView.isHidden = true
//            dismiss(animated: true, completion: nil)
//        }
//    }
//
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//        let y = scrollView.contentOffset.y
//        let alpha = (y + 200)/100
//        headerBgView.alpha = alpha
//    }
//
}
