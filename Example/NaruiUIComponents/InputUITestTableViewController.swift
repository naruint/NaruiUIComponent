//
//  InputUITestTableViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyeol Seo on 2020/10/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class InputUITestTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         self.clearsSelectionOnViewWillAppear = false

         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }



}
