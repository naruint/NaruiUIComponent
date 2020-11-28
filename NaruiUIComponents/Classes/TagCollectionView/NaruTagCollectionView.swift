//
//  NaruTagCollectionView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/26.
//

import UIKit
@IBDesignable
public class NaruTagCollectionView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBInspectable var cell_borderColor:UIColor = .red
    @IBInspectable var cell_bgColor:UIColor = .gray
    @IBInspectable var textColor:UIColor = .black
    @IBInspectable var prefix:String = "#"
    public var tags:[String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    //MARK: - arrangeView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        arrangeView()
    }
    
    func arrangeView() {
        guard let view = finedView(nibName: String(describing: NaruTagCollectionView.self), id: "view") else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NaruTagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
}

extension NaruTagCollectionView : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NaruTagCollectionViewCell
        cell.text = prefix + tags[indexPath.row]
        cell.setColor(textColor: textColor, borderColor: cell_borderColor, bgColor: cell_bgColor)
        return cell
    }
    
}

extension NaruTagCollectionView : UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = prefix + tags[indexPath.row]
        let newSize = NSString(string: text).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
        return CGSize(width: newSize.width + 30, height: 28)
    }
}
