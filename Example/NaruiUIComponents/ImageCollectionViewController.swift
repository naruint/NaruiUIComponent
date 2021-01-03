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

fileprivate func getIsSelected(model:ImageCollectionViewController.ViewModel, selectedModels:Set<ImageCollectionViewController.ViewModel>)->Bool {
    return selectedModels.firstIndex(where: { (m) -> Bool in
        return m == model
    }) != nil
}

fileprivate func getBottomDecoType(model:ImageCollectionViewController.ViewModel, selectedModels:Set<ImageCollectionViewController.ViewModel>)->NaruImageView.BottomDecoStyle {
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

fileprivate func getAlpha(model:ImageCollectionViewController.ViewModel, selectedModels:Set<ImageCollectionViewController.ViewModel>)->CGFloat {
    switch selectedModels.count {
    case 2:
        if selectedModels.firstIndex(where: { (m) -> Bool in
            return model == m
        }) != nil {
            return 1.0
        }
        return 0.5
    case 1:
        if selectedModels.first?.group != model.group || selectedModels.first == model {
            return 1.0
        }
        return 0.5
    default:
        return 1.0
    }
}

class ImageCollectionViewController: UICollectionViewController {
    struct ViewModel : Hashable {
        let url:URL?
        let musicURL:URL?
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
    
    let playerView = NaruMusicPlayerMiniView()

    
    let models = [
        [
            ViewModel(url:
                        URL(string: "https://i.pinimg.com/originals/34/6e/df/346edf41cf7de5ba8a37d34a4771a4f0.jpg"),
                      musicURL: URL(string: "https://www.dropbox.com/s/6lrki8rfyx0hi1r/effect1.mp3?dl=1"),
                      group: "A"),
            ViewModel(url: URL(string: "https://file3.instiz.net/data/file3/2018/06/21/b/4/0/b40633dd9df9e4ab4371b6a4f8801cdd.jpg"),
                      musicURL: URL(string: "https://www.dropbox.com/s/6lrki8rfyx0hi1r/effect1.mp3?dl=1"),
                      group: "A"),
            ViewModel(url: URL(string: "https://i.pinimg.com/originals/68/94/93/6894931eb3e93f6d6ef2dd000d8acdc6.jpg"),
                      musicURL: URL(string: "https://www.dropbox.com/s/6lrki8rfyx0hi1r/effect1.mp3?dl=1"),
                      group: "A"),
            ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1B4uflzH2bZd3i1edrC2Td9JWtXTP48k7AQ&usqp=CAU"),
                      musicURL: URL(string: "https://www.dropbox.com/s/6lrki8rfyx0hi1r/effect1.mp3?dl=1"),
                      group: "A")
 
        ], [
            ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-owPs2ltRxvf749lE3FwkOAx03put-HqjYw&usqp=CAU"),
                      musicURL: URL(string: "https://www.dropbox.com/s/jryrixqfe8zupn5/music4.mp3?dl=1"),
                      group: "B"),
            ViewModel(url: URL(string: "https://img2.quasarzone.com/editor/2020/08/29/fe477ba0e01ca8d38d28650b9a11b108.jpg"),
                      musicURL: URL(string: "https://www.dropbox.com/s/3zxrrryqh0s3u1i/music5.mp3?dl=1"),
                      group: "B"),
            ViewModel(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBZ0U7sYvpeZbinWr7sX_xdkS5AhosCzNB1A&usqp=CAU"),
                      musicURL: URL(string: "https://www.dropbox.com/s/op5tk9kte5saafn/music3.mp3?dl=1"),
                      group: "B"),
            ViewModel(url: URL(string: "https://cdn.pixabay.com/photo/2019/10/14/09/39/cat-4548385_960_720.jpg"),
                      musicURL: URL(string: "https://www.dropbox.com/s/9dtmsf4r1jxctst/music2.mp3?dl=1"),
                      group: "B"),
            ViewModel(url: URL(string: "https://t1.daumcdn.net/cfile/blog/1676324D4DE12D7415"),
                      musicURL: URL(string: "https://www.dropbox.com/s/t4i0c2jbknbf7j6/music1.mp3?dl=1"),
                      group: "B")
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
        cell.imageView.isSelected = getIsSelected(model: model,selectedModels: selectedModels)
        cell.imageView.bottomDecoStyle = getBottomDecoType(model: model,selectedModels: selectedModels)
        cell.imageView.alpha = getAlpha(model: model,selectedModels: selectedModels)
        cell.titleLabel.text = "고양이 \(model.group)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ImageCollectionHeader
        cell.label.text = models[indexPath.section][indexPath.row].group
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.section][indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        func toggle() {
            if selectedModels.firstIndex(where: { (m) -> Bool in
                m == model
            }) == nil {
                selectedModels.insert(model)
                NaruAudioPlayer.shared.insertMusic(url: model.musicURL, isFirstTrack: model.group == "B")
                playerView.showPlayer(targetViewController: self)
            } else {
                selectedModels.remove(model)
                NaruAudioPlayer.shared.removeMusic(url: model.musicURL)
            }
        }
        
        NaruAudioPlayer.shared.play(title: model.musicURL?.absoluteString ?? "음악" , subTitle: "", artworkImageURL: nil, seqNo: "\(model.hashValue)")
        
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
        cell.imageView.isSelected = getIsSelected(model: model,selectedModels: selectedModels)
        cell.imageView.bottomDecoStyle = getBottomDecoType(model: model,selectedModels: selectedModels)
        cell.imageView.alpha = getAlpha(model: model, selectedModels: selectedModels)
        
        NaruAudioPlayer.shared.play(title: "test", subTitle: "산들바람 솔솔", artworkImageURL: URL(string: "https://i.pinimg.com/originals/34/6e/df/346edf41cf7de5ba8a37d34a4771a4f0.jpg"), seqNo: "\(model.hashValue)")
        
    }
}


class ImageCollectionViewCell:UICollectionViewCell {
    var viewModel:ImageCollectionViewController.ViewModel? = nil
    @IBOutlet weak var imageView: NaruImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        NotificationCenter.default.addObserver(forName: .imageSelectedChange, object: nil, queue: nil) { [weak self] (noti) in
            guard let model = self?.viewModel ,
                  let models = noti.object as? Set<ImageCollectionViewController.ViewModel>
                  else {
                return
            }
            self?.imageView.isSelected = getIsSelected(model: model,selectedModels: models)
            self?.imageView.bottomDecoStyle = getBottomDecoType(model: model,selectedModels: models)
            UIView.animate(withDuration: 0.25) {
                self?.imageView.alpha = getAlpha(model: model, selectedModels: models)
            }
        }
        
    }
}

class ImageCollectionHeader: UICollectionReusableView {
    @IBOutlet weak var label:UILabel!
}
