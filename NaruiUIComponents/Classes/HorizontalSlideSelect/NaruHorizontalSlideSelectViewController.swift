//
//  NaruHorizontalSlideSelectViewController.swift
//  UITest
//
//  Created by Changyeol Seo on 2020/10/12.
//

import UIKit

fileprivate var selectedIndex:[Int:Int] = [:]

public class NaruHorizontalSlideSelectViewController: UIViewController {

    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectItemTitleLabel: UILabel!
    @IBOutlet weak var selectItemSubTitleLabel: UILabel!
    @IBOutlet weak var slideSelectView: NaruHorizontalSlideSelectView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    public class var viewController:NaruHorizontalSlideSelectViewController {
        if #available(iOS 13.0, *) {
            return UIStoryboard(name: "NaruHorizontalSlideSelect", bundle: nil).instantiateViewController(identifier: "home")
        } else {
            return UIStoryboard(name: "NaruHorizontalSlideSelect", bundle: nil).instantiateViewController(withIdentifier: "home") as! NaruHorizontalSlideSelectViewController
        }
    }    
    
    public var qustionData:ViewModel? = nil
    var page = 0
    
    var datas:[AnswerModel] {
        if let data = qustionData {
            return data.datas[page].answers
        }
        return []
    }
    
    var totalQustionCount:Int {
        qustionData?.datas.count ?? 0
    }
    
    private var _didConfirm:(_ result:[Int])->Void = { _ in }
    private var viewModel:QuestionModel? = nil
    
    
    public func setDidConfirm(didConfirm:@escaping(_ result:[Int])->Void) {
        self._didConfirm = didConfirm
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if qustionData ==  nil {
            return
        }
        
        
        slideSelectView.delegate = self
        slideSelectView.datas = datas
        slideSelectView.selectedIndex = datas.count / 2
        viewModel = qustionData?.datas[page].question
        
        title = viewModel?.title
        titleLabel.text = viewModel?.desc
        pageLabel.text = "\(page + 1) / \(totalQustionCount)"
    }
    
    
    @IBAction func onTouchupButton(_ sender:UIButton) {
        selectedIndex[page] = slideSelectView.selectedIndex
        if page + 1 < totalQustionCount {
            let vc = NaruHorizontalSlideSelectViewController.viewController
            vc.qustionData = self.qustionData
            vc.page = self.page + 1
            vc.setDidConfirm(didConfirm: _didConfirm)
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            var result:[Int] = []
            for item in  selectedIndex.sorted(by: { (a, b) -> Bool in
                a.key < b.key
            }) {
                result.append(item.value)
            }
            _didConfirm(result)
        }
    }
}

extension NaruHorizontalSlideSelectViewController : NaruHorizontalSlideSelectViewDelegate {
    func selectItem(item: AnswerModel, isShow: Bool) {
        selectItemTitleLabel.text = item.longTitle
        selectItemSubTitleLabel.text = item.desc

//        if let subtitle = item.subTitle {
//            selectItemTitleLabel.text = "\(item.title) \(subtitle)"
//        }
         // 라벨 컨테이너 레이어 띄우기 애니메이션 처리 (페이드인, 아웃)
        if isShow && labelContainerView.isHidden {
            labelContainerView.isHidden = false
            labelContainerView.alpha = 0
            UIView.animate(withDuration: 0.5) { [unowned self] in
                labelContainerView.alpha = 1
            }
        }
        else if !isShow && labelContainerView.isHidden == false  {
            UIView.animate(withDuration: 0.5) { [unowned self] in
                labelContainerView.alpha  = 0
            } completion: {  [unowned self] (fin) in
                labelContainerView.isHidden = true
            }
        }
    }
    func focusChange(isOn: Bool) {
        UIView.animate(withDuration: 0.2) {[weak self] in
            for view in [self?.bottomView] {
                view?.alpha = isOn ? 0 : 1
            }
        }
    }
}
