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
        ViewModel(url: URL(string: "https://i.pinimg.com/originals/68/94/93/6894931eb3e93f6d6ef2dd000d8acdc6.jpg"), group: "A"),
        ViewModel(url: URL(string: "https://i.pinimg.com/originals/34/6e/df/346edf41cf7de5ba8a37d34a4771a4f0.jpg"), group: "B"),
        ViewModel(url: URL(string: "https://file3.instiz.net/data/file3/2018/06/21/b/4/0/b40633dd9df9e4ab4371b6a4f8801cdd.jpg"), group: "A"),
        ViewModel(url: URL(string: "https://i.pinimg.com/originals/68/94/93/6894931eb3e93f6d6ef2dd000d8acdc6.jpg"), group: "A"),
        ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1B4uflzH2bZd3i1edrC2Td9JWtXTP48k7AQ&usqp=CAU"), group: "A"),
        ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-owPs2ltRxvf749lE3FwkOAx03put-HqjYw&usqp=CAU"), group: "B"),
        ViewModel(url: URL(string: "https://img2.quasarzone.com/editor/2020/08/29/fe477ba0e01ca8d38d28650b9a11b108.jpg"), group: "B"),
        ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBZ0U7sYvpeZbinWr7sX_xdkS5AhosCzNB1A&usqp=CAU"), group: "B"),
        ViewModel(url: URL(string: "https://cdn.pixabay.com/photo/2019/10/14/09/39/cat-4548385_960_720.jpg"), group: "B"),
        ViewModel(url: URL(string: "https://t1.daumcdn.net/cfile/blog/1676324D4DE12D7415"),group: "A")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return models.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        let model = models[indexPath.row]
        cell.viewModel = model
        cell.imageView.setImage(with: model.url)
//        cell.imageView.bottomDecoStyle = .mix
        // Configure the cell
    
        return cell
    }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        let isMixAble = selectedModels.first?.group != model.group
        if selectedModels.count < 2 {
            cell.imageView.isSelected.toggle()
            if cell.imageView.isSelected {
                selectedModels.insert(model)
            } else {
                selectedModels.remove(model)
            }
            cell.imageView.bottomDecoStyle =
                cell.imageView.isSelected ? .play : isMixAble ? .mix : .none
            
        } else {
            if cell.imageView.isSelected {
                cell.imageView.isSelected = false
                selectedModels.remove(model)
            }
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
            if let models = noti.object as? Set<ImageCollectionViewController.ViewModel> {
                if self?.imageView.isSelected == false {
                    if models.count >= 2 || models.count == 0 {
                        self?.imageView.bottomDecoStyle = .none
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
