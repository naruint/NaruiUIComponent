//
//  SimplePinNumberTestViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyeol Seo on 2020/11/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NaruiUIComponents
import RxCocoa
import RxSwift

class SimplePinNumberTestViewController: UIViewController {

    @IBOutlet weak var pinNumberView: NaruSimplePinNumberView!
    
    @IBOutlet var buttons: [UIButton]!
    struct ButtonData {
        enum ButtonType {
            case number
            case backSpace
            case reload
        }
        let value:String
        let type:ButtonType
    }
    
    let datas:[ButtonData] = [
        ButtonData(value: "1", type: .number),ButtonData(value: "2", type: .number),ButtonData(value: "3", type: .number),
        ButtonData(value: "4", type: .number),ButtonData(value: "5", type: .number),ButtonData(value: "6", type: .number),
        ButtonData(value: "7", type: .number),ButtonData(value: "8", type: .number),ButtonData(value: "9", type: .number),
        ButtonData(value: "*", type: .reload),ButtonData(value: "0", type: .number),ButtonData(value: "<", type: .backSpace),
    ]
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for (index,btn) in buttons.enumerated() {
            let data = datas[index]
            btn.setTitle(data.value, for: .normal)
            btn.rx.tap.bind { [unowned self](_) in
                
                switch data.type {
                case .number:
                    pinNumberView.append(text: datas[index].value)
                case .backSpace:
                    pinNumberView.removeLast()
                case .reload:
                    pinNumberView.text = nil
                }
                
            }.disposed(by: disposeBag)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
