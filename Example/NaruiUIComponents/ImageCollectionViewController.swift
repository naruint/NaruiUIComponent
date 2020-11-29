//
//  ImageCollectionViewController.swift
//  NaruiUIComponents_Example
//
//  Created by Changyul Seo on 2020/11/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import NaruiUIComponents
fileprivate extension Notification.Name {
    static let imageSelectedChange = Notification.Name("imageSelectedChange_observer")
}

class ImageCollectionViewController: UICollectionViewController {
    struct ViewModel : Hashable {
        let url:URL?
        let group:String
        
        public static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            return lhs.url == rhs.url && lhs.group == rhs.group
        }
    }
    
    var selectedModels = Set<ViewModel>() {
        didSet {
            NotificationCenter.default.post(name: .imageSelectedChange, object: selectedModels)
        }
    }
    
    let models = [
        [
            ViewModel(url: URL(string: "https://i.pinimg.com/originals/34/6e/df/346edf41cf7de5ba8a37d34a4771a4f0.jpg"), group: "A"),
            ViewModel(url: URL(string: "https://file3.instiz.net/data/file3/2018/06/21/b/4/0/b40633dd9df9e4ab4371b6a4f8801cdd.jpg"), group: "B"),
            ViewModel(url: URL(string: "https://i.pinimg.com/originals/68/94/93/6894931eb3e93f6d6ef2dd000d8acdc6.jpg"), group: "B"),
            ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1B4uflzH2bZd3i1edrC2Td9JWtXTP48k7AQ&usqp=CAU"), group: "B"),
 
        ], [
            ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-owPs2ltRxvf749lE3FwkOAx03put-HqjYw&usqp=CAU"), group: "B"),
            ViewModel(url: URL(string: "https://img2.quasarzone.com/editor/2020/08/29/fe477ba0e01ca8d38d28650b9a11b108.jpg"), group: "A"),
            ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBZ0U7sYvpeZbinWr7sX_xdkS5AhosCzNB1A&usqp=CAU"), group: "A"),
            ViewModel(url: URL(string: "https://cdn.pixabay.com/photo/2019/10/14/09/39/cat-4548385_960_720.jpg"), group: "B"),
            ViewModel(url: URL(string: "https://t1.daumcdn.net/cfile/blog/1676324D4DE12D7415"),group: "A")
        ]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return models.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return models[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        let model = models[indexPath.section][indexPath.row]
        cell.viewModel = model
        cell.imageView.setImage(with: model.url)
        cell.imageView.isSelected = getIsSelected(model: model)
        cell.imageView.bottomDecoStyle = getBottomDecoType(model: model)
        cell.imageView.alpha = getAlpha(model: model)
        return cell
    }
    
    func getIsSelected(model:ViewModel)->Bool {
        return selectedModels.firstIndex(where: { (m) -> Bool in
            return m == model
        }) != nil
    }
    
    func getBottomDecoType(model:ViewModel)->NaruImageView.BottomDecoStyle {
        switch selectedModels.count {
        case 0:
            return .none
        case 1:
            if selectedModels.first == model {
                return .play
            }
            if selectedModels.first?.group != model.group {
                return .mix
            }
            return .none
        case 2:
            if selectedModels.firstIndex(where: { (m) -> Bool in
                return model == m
            }) != nil {
                return .play
            }
            return .none
        default:
            return .none
        }
    }
    
    func getAlpha(model:ViewModel)->CGFloat {
        if selectedModels.count == 2 {
            if selectedModels.firstIndex(where: { (m) -> Bool in
                return model == m
            }) != nil {
                return 1.0
            }
            return 0.5
        }
        return 1.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.section][indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        func toggle() {
            if selectedModels.firstIndex(where: { (m) -> Bool in
                m == model
            }) == nil {
                selectedModels.insert(model)
            } else {
                selectedModels.remove(model)
            }
        }

        switch selectedModels.count {
        case 2:
            if selectedModels.firstIndex(where: { (m) -> Bool in
                return m == model
            }) != nil  {
                toggle()
                if cell.imageView.isSelected {
                    selectedModels.remove(model)
                }
            }
        case 1:
            if selectedModels.first?.group != model.group || selectedModels.first == model {
                toggle()
            }
        case 0:
            toggle()
        default:
            break
        }
        cell.imageView.isSelected = getIsSelected(model: model)
        cell.imageView.bottomDecoStyle = getBottomDecoType(model: model)
        UIView.animate(withDuration: 0.25) {[weak self]in
            cell.imageView.alpha = self?.getAlpha(model: model) ?? 0
        }
    }
}


class ImageCollectionViewCell:UICollectionViewCell {
    var viewModel:ImageCollectionViewController.ViewModel? = nil
    @IBOutlet weak var imageView: NaruImageView!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        NotificationCenter.default.addObserver(forName: .imageSelectedChange, object: nil, queue: nil) { [weak self] (noti) in
            guard let model = self?.viewModel else {
                return
            }
            self?.imageView.alpha = 1.0
            if let models = noti.object as? Set<ImageCollectionViewController.ViewModel> {
                if self?.imageView.isSelected == false {
                    if models.count >= 2 || models.count == 0 {
                        self?.imageView.bottomDecoStyle = .none
                        if models.count == 2 {
                            UIView.animate(withDuration: 0.25) {
                                self?.imageView.alpha = 0.5
                            }
                        }
                    }
                    else if models.first?.group != model.group {
                        self?.imageView.bottomDecoStyle = .mix
                    } else {
                        self?.imageView.bottomDecoStyle = .none
                    }
                }
            }
        }
        
    }
}
