//
//  TableViewController.swift
//  UITest
//
//  Created by Changyeol Seo on 2020/10/12.
//

import UIKit
import NaruiUIComponents

class TableViewController: UITableViewController {
    enum CellType : String, CaseIterable {
        case horizontalSlideSelect = "horizontalSlideSelect"
        case twoDepthFilter = "twoDepthFilter"
        case inputTest = "input test"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "home"
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = CellType.allCases[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch CellType.allCases[indexPath.row] {
        //MARK:horizontalSlideSelect
        case .horizontalSlideSelect:
            let vc = NaruHorizontalSlideSelectViewController.viewController
            let jsonStr:String = """
{
"datas" : [
{
    "question" : {
        "title":"질문",
        "desc":"재미있거나 즐겨하는 일이 있나요?",
        "confirmtitle":"다음"
     },
    "answers" : [
        {
            "title":"전혀",
            "longTitle":"전혀 없어요",
            "subTitle":"",
            "desc":"없어서 심심해요"
        },
        {
            "title":"조금",
            "longTitle":"조금 있어요",
            "subTitle":"",
            "desc":"기분전환 좀 해요"
        },
        {
            "title":"가끔",
            "longTitle":"가끔 있어요",
            "subTitle":"",
            "desc":"살만해요"
        },
        {
            "title":"자주",
            "longTitle":"자주 있어요",
            "subTitle":"",
            "desc":"삶이 재미있어요"
        },
        {
            "title":"항상",
            "longTitle":"항상 있어요",
            "subTitle":"",
            "desc":"익사이팅"
        }
    ]
},
{
    "question" : {
        "title":"질문2",
        "desc":"오늘은 책 읽었어요?",
        "confirmtitle":"확인"
     },
    "answers" : [
        {
            "title":"전혀",
            "longTitle":"하나도 안 읽었어요",
            "subTitle":"",
            "desc":"책 읽을 시간 없어요"
        },
        {
            "title":"조금",
            "longTitle":"10페이지 쯤",
            "subTitle":"",
            "desc":"잠깐 짬내서 읽었어요"
        },
        {
            "title":"보통",
            "longTitle":"적당히 읽었어요",
            "subTitle":"",
            "desc":"책은 마음의 양식이죠"
        },
        {
            "title":"많이",
            "longTitle":"많이 읽었어요.",
            "subTitle":"",
            "desc":"2권쯤 읽은거 같아요"
        },
        {
            "title":"종일",
            "longTitle":"하루종일 독서 삼매경",
            "subTitle":"",
            "desc":"책만 읽었어요"
        }
    ]
}
]
}
"""
            if let data = NaruHorizontalSlideSelectViewController.ViewModel.makeModel(string:jsonStr) {
                vc.qustionData = data
                vc.setDidConfirm { [weak self](result) in
                    guard let s = self else {
                        return
                    }
                    s.navigationController?.popToViewController(s, animated: true)
                    let ac = UIAlertController(title: "result", message: "\(result)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "confirm", style: .cancel, handler: nil))
                    s.present(ac, animated: true, completion: nil)

                }
            }
            navigationController?.pushViewController(vc, animated: true)
        case .twoDepthFilter:
            //MARK:twoDepthFilter
            performSegue(withIdentifier: "showTwoDepthFIlterTestView", sender: nil)
        case .inputTest:
            //MARK:inputTest
            performSegue(withIdentifier: "showInputTest", sender: nil)
        }
    }
    
}
