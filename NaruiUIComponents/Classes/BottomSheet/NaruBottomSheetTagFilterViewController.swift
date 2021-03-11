//
//  NaruBottomSheetTagFilterViewController.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/27.
//

import UIKit
import TagListView
import RxCocoa
import RxSwift

fileprivate var preSelectedTags:[String:[String]]? = nil

public extension Notification.Name {
    static let naruBottomSheetTagFilterSelectionDidChange = Notification.Name("naruBottomSheetTagFilterSelectionDidChange_observer")
}

extension Notification.Name {
    static let naruBottomSheetTagCellFilterSelectionDidChange = Notification.Name("naruBottomSheetTagCellFilterSelectionDidChange_observer")
    static let naruBottomSheetTableViewCellHeightDidChange = Notification.Name("naruBottomSheetTableViewCellHeightDidChange_observer")
}

public class NaruBottomSheetTagFilterViewController: UIViewController {
    @IBOutlet var headerView: UIView!
    deinit {
        // print("NaruBottomSheetTagFilterViewController deinit!!")
    }

    public struct Model {
        public struct Tag {
            public let text:String
            public let prefix:String?
            public var displayText:String {
                return "\(prefix ?? "")\(text)"
            }
            public init(text:String, prefix:String?) {
                self.text = text
                self.prefix = prefix
            }
        }
        public struct FilterSet {
            public let title:String
            public let isMultipleSelect:Bool
            public let tags:[Tag]
            public init(title:String, isMultipleSelect:Bool, tags:[Tag]) {
                self.title = title
                self.isMultipleSelect = isMultipleSelect
                self.tags = tags
            }
        }
    }
    
    public func setFilterSet(set:[Model.FilterSet]) {
        self.filterSets = set
    }
    
    public var filterSets:[Model.FilterSet] = [
        Model.FilterSet(
            title: "상태", isMultipleSelect: true ,tags: [
                Model.Tag(text: "숙면", prefix: "#"),
                Model.Tag(text: "스트레스해소", prefix: "#"),
                Model.Tag(text: "체력증진", prefix: "#"),
                Model.Tag(text: "우울해소", prefix: "#"),
                Model.Tag(text: "불안해소", prefix: "#"),
            ]),
        Model.FilterSet(
            title: "클래스", isMultipleSelect: false, tags: [
                Model.Tag(text: "홈트레이닝", prefix: nil),
                Model.Tag(text: "댄스카디오", prefix: nil),
                Model.Tag(text: "요가&명상", prefix: nil),
                Model.Tag(text: "북테라피", prefix: nil),
                Model.Tag(text: "사운드테라피", prefix: nil),
            ])
    ]
    
    public static var viewController : NaruBottomSheetTagFilterViewController {
        let storyboard = UIStoryboard(name: "NaruBottomSheets", bundle: Bundle(for: NaruBottomSheetTagFilterViewController.self))
        if #available(iOS 13.0, *) {
            return storyboard.instantiateViewController(identifier: "tagFilter")
        } else {
            return storyboard.instantiateViewController(withIdentifier: "tagFilter") as! NaruBottomSheetTagFilterViewController
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    var result:[String:[String]] = [:]
    
    let disposeBag = DisposeBag()
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        let image = UIImage(named: "03Icon24CloseBlack",in: Bundle(for: NaruBottomSheetTagFilterViewController.self), compatibleWith: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.onTouchupDismissBtn(_:)))
        applyButton.setBackgroundImage(UIColor(white: 0.5, alpha: 0.5).image, for: .highlighted)
        
        NotificationCenter.default.addObserver(forName: .naruBottomSheetTagCellFilterSelectionDidChange, object: nil, queue: nil) { [weak self](noti) in
            guard let tags = noti.object as? [String],
                  let title = noti.userInfo?["title"] as? String else {
                return
            }
            self?.result[title] = tags
        }
        
        applyButton.rx.tap.bind { [unowned self](_) in
           
            NotificationCenter.default.post(name: .naruBottomSheetTagFilterSelectionDidChange, object: result)
            dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
        
    public func setTags(selectedTags:[String:[String]]){
        preSelectedTags = selectedTags
        result = selectedTags
        self.tableView?.reloadData()
    }
    
    @objc func onTouchupDismissBtn(_ sender:UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension NaruBottomSheetTagFilterViewController : UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterSets.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterSet = filterSets[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NaruBottomSheetTagFilterTableViewCell
        cell.data = filterSet
        return cell
    }
}


class NaruBottomSheetTagFilterTableViewCell : UITableViewCell {
    var data:NaruBottomSheetTagFilterViewController.Model.FilterSet? = nil {
        didSet {
            DispatchQueue.main.async {[weak self]in
                self?.updateUI()
            }
        }
    }
    
    var selectedTags:[String] {
        var result:[String] = []
        for view in tagListView.selectedTags() {
            if let title = view.currentTitle {
                if let prefix = data?.tags.first?.prefix {
                    let new = title[prefix.count..<title.count]
                    result.append(new)
                } else {
                    result.append(title)
                }
            }
        }
        return result
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var tagListViewHeight: NSLayoutConstraint!
    override func didMoveToWindow() {
        super.didMoveToWindow()
        tagListView.autoresizingMask = [.flexibleHeight]
        fixlayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fixlayout()
    }
    
    func fixlayout() {
        let oldHeight = tagListViewHeight.constant
        
        tagListView.textFont = UIFont.systemFont(ofSize: 12)
        let newHeight = tagListView.intrinsicContentSize.height
        if oldHeight != newHeight {
            tagListViewHeight.constant = newHeight + tagListView.paddingY + tagListView.marginY + 12
            NotificationCenter.default.post(name: .naruBottomSheetTableViewCellHeightDidChange, object: nil)
        }
    }
    
    func updateUI() {
        let title = data?.title ?? ""
        titleLabel.text = title
        tagListView.removeAllTags()

        for tag in data?.tags ?? [] {
            let tagView = tagListView.addTag(tag.displayText)
            let stags = preSelectedTags?[title] ?? []
            let isSelected = stags.filter { (str) -> Bool in
                return str == tag.text
            }.count > 0
            tagView.isSelected = isSelected
    
            tagView.onTap = { [weak self] tagView in
                if self?.data?.isMultipleSelect == false && tagView.isSelected == false {
                    for view in self?.tagListView.tagViews ?? [] {
                        view.isSelected = false
                    }
                }
                tagView.isSelected.toggle()
                self?.notiResult()
            }
            tagView.onLongPress = { _ in
            }
        }
        fixlayout()
    }
    
    func notiResult() {
        NotificationCenter.default.post(
            name: .naruBottomSheetTagCellFilterSelectionDidChange,
            object: selectedTags,
            userInfo: ["title" : data?.title ?? ""] )
    }
    
}
