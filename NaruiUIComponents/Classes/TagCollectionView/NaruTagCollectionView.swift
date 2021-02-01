//
//  NaruTagCollectionView.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/11/26.
//

import UIKit
//@IBDesignable
public class NaruTagCollectionView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBInspectable var cell_borderColor:UIColor = .red
    @IBInspectable var cell_bgColor:UIColor = .gray
    @IBInspectable var cell_selectedBgColor:UIColor? = nil
    @IBInspectable var cell_highlightBgColor:UIColor? = nil
    @IBInspectable var textColor:UIColor = .black
    @IBInspectable var prefix:String = "#"
    
    public func setCellStyle(borderColor:UIColor, bgColor:UIColor, selectedBgColor:UIColor, highlightBgColor:UIColor,textColor:UIColor,prefix:String) {
        cell_borderColor = borderColor
        cell_bgColor = bgColor
        cell_selectedBgColor = selectedBgColor
        cell_highlightBgColor = highlightBgColor
        self.textColor = textColor
        self.prefix = prefix
        self.collectionView.reloadData()
    }
    
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
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NaruTagCollectionViewCell
        if let c = cell_highlightBgColor {
            cell.backgroundColor = c
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NaruTagCollectionViewCell
        if let c = cell_selectedBgColor {
            cell.backgroundColor = c
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NaruTagCollectionViewCell
        cell.backgroundColor = cell_bgColor
    }
}

extension NaruTagCollectionView : UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = prefix + tags[indexPath.row]
        let newSize = NSString(string: text).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)])
        return CGSize(width: newSize.width + 20, height: 28)
    }
}
