//
//  TwoDepthFilterTestTableViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyeol Seo on 2020/10/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NaruiUIComponents

class TwoDepthFilterTestTableViewController: UITableViewController {

    @IBOutlet weak var filterView: NaruTwoDepthFilterView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonStr = """
{
        "filters":[
        {
            "title":"음악",
            "subtitles":[
                {"title":"국악", "value":0},
                {"title":"힙합", "value":0},
                {"title":"록", "value":0},
                {"title":"클래식", "value":0}
            ]
        },
        {
            "title":"영화",
            "subtitles":[
                {"title":"한국영화", "value":0},
                {"title":"미국영화", "value":0},
                {"title":"중국영화", "value":0},
                {"title":"인도영화", "value":0}
            ]
        },
        {
            "title":"운동",
            "subtitles":[
                {"title":"", "value":0},
                {"title":"", "value":1},
                {"title":"", "value":2},
                {"title":"", "value":3},
            ]
        }
        ]
}
"""
        if let data = NaruTwoDepthFilterView.ViewModel.makeModel(string: jsonStr) {
            filterView.data = data
            print(data)
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
