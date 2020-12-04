//
//  NaruLandScapeVideoViewController.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/12/04.
//

import Foundation
import UIKit

class NaruLandscapeVideoViewController: UIViewController {
    
    let playerControllerView = NaruVideoControllerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.
        addPlayerController()
        playerControllerView.targetViewController = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // orientation
    
    
    private func addPlayerController() {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // swap width & height becox the mainScreen is still in portrait
        playerControllerView.frame = CGRect(x: 0, y: 0, width: screenHeight, height: screenWidth)
        
        playerControllerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerControllerView)
        
        let top = NSLayoutConstraint(item: playerControllerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: playerControllerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: playerControllerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: playerControllerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        view.addConstraints([top, bottom, leading, trailing])
    }
}
