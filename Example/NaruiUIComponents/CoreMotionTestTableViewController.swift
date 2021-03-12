//
//  CoreMotionTestTableViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyeol Seo on 2021/03/12.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import CoreMotion

class CoreMotionTestTableViewController: UITableViewController {
    let motionManager = CMMotionManager()

    @IBOutlet var labels: [UILabel]!
    @IBOutlet var progresses: [UIProgressView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager.gyroUpdateInterval = 0.2
        motionManager.startGyroUpdates(to: .main) { [weak self](data, error) in
            if error != nil {
                self?.motionManager.stopGyroUpdates()
            }
            else if let rate = data?.rotationRate {
                self?.labels[3].text = "x : \(Float(Int(rate.x * 100))/100)"
                self?.labels[4].text = "y : \(Float(Int(rate.y * 100))/100)"
                self?.labels[5].text = "z : \(Float(Int(rate.x * 100))/100)"
                
                self?.progresses[3].progress = Float(rate.x.magnitude)
                self?.progresses[4].progress = Float(rate.y.magnitude)
                self?.progresses[5].progress = Float(rate.z.magnitude)
                
                self?.progresses[3].tintColor = rate.x == 0 ? .white : rate.x > 0 ? .blue : .red
                self?.progresses[4].tintColor = rate.x == 0 ? .white : rate.y > 0 ? .blue : .red
                self?.progresses[5].tintColor = rate.x == 0 ? .white : rate.z > 0 ? .blue : .red
            }
        
        }

        motionManager.accelerometerUpdateInterval = 0.2
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { [weak self](data, error) in
                if error != nil {
                    self?.motionManager.stopAccelerometerUpdates()
                }
                else {
                    if let acc = data?.acceleration {
                        self?.labels[0].text = "x : \(Float(Int(acc.x * 100))/100)"
                        self?.labels[1].text = "y : \(Float(Int(acc.y * 100))/100)"
                        self?.labels[2].text = "z : \(Float(Int(acc.x * 100))/100)"
                        
                        self?.progresses[0].progress = Float(acc.x.magnitude)
                        self?.progresses[1].progress = Float(acc.y.magnitude)
                        self?.progresses[2].progress = Float(acc.z.magnitude)
                        
                        self?.progresses[0].tintColor = acc.x == 0 ? .white : acc.x > 0 ? .blue : .red
                        self?.progresses[1].tintColor = acc.x == 0 ? .white : acc.y > 0 ? .blue : .red                
                        self?.progresses[2].tintColor = acc.x == 0 ? .white : acc.z > 0 ? .blue : .red
                    
                    }
                }
            }
        }
        
    }

 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

}
