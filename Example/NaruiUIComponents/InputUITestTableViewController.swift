//
//  InputUITestTableViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyeol Seo on 2020/10/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NaruiUIComponents

class InputUITestTableViewController: UITableViewController {
    @IBOutlet weak var nameTextField: NaruTextField!
    @IBOutlet weak var ageTextField: NaruTextField!
    @IBOutlet weak var birthdayTextField: NaruTextField!
    @IBOutlet weak var genderSelectView: NaruSelectBoxView!
    
    @IBOutlet weak var emailTextField: NaruTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
     
        for tf in [nameTextField, ageTextField, birthdayTextField] {
            tf?.returnKeyType = .continue
        }
        nameTextField.setReturn { [unowned self] tf in
            _ = ageTextField.becomeFirstResponder()
        }
        ageTextField.setReturn { [unowned self] tf in
            _ = birthdayTextField.becomeFirstResponder()
        }
        birthdayTextField.setReturn { [unowned self] tf in
            _ = emailTextField.becomeFirstResponder()
        }
        ageTextField.keyboardType = .numberPad
        emailTextField.keyboardType = .emailAddress
        
        emailTextField.setRightButton(title: "이메일이 생각 안나나요?"
                                      , font: UIFont.systemFont(ofSize: 8)
                                      , normalColor: .blue
                                      , highlightedColor: .yellow
                                      , isHideRightViewWhenInput: true) { [unowned self] in
            let ac = UIAlertController(title: "유감입니다.", message: "잘 생각해보세요", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    

}
