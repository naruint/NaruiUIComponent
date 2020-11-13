//
//  NaruGraphView.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/30.
//

import UIKit

public class NaruGraphView: UIView {
    @IBOutlet var graphItemViews: [NaruGraphItemView]!
    //MARK:-
//MARK:arrangeView
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        arrangeView()
    }
    
    func arrangeView() {
        guard let view = UINib(
                nibName: String(describing: NaruGraphView.self),
                bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        view.frame = bounds
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    public var data:ViewModel? = nil {
        didSet {
            guard let data = data else {
                return
            }
            for (index,item) in data.values.enumerated() {
                graphItemViews[index].data = item
            }
        }
    }
    
    var points:[CGPoint] {
        guard let data = data else {
            return []
        }
        let intervalX = bounds.width / CGFloat(data.values.count - 1)
        var result:[CGPoint] = []
        for (index,value) in data.values.enumerated() {
            let x:CGFloat = CGFloat(index) * intervalX
            let y:CGFloat = CGFloat(value.value) * bounds.height
            result.append(CGPoint(x: x, y: bounds.height - y))
        }
        return result
    }
//
//    var c1points:[CGPoint] {
//        var result:[CGPoint] = []
//        for (index,a) in points.enumerated() {
//            if points.count > index + 1 {
//                let b = points[index + 1]
//                result.append(CGPoint(x: b.x, y: a.y))
//            }
//            else {
//                result.append(a)
//            }
//        }
//        return result
//    }
//
//    var c2points:[CGPoint] {
//        var result:[CGPoint] = []
//        for (index,a) in points.enumerated() {
//            if points.count > index + 1 {
//                let b = points[index + 1]
//                result.append(CGPoint(x: a.x, y: b.y))
//            } else {
//                result.append(a)
//            }
//        }
//        return result
//    }
//
//    public override func draw(_ rect: CGRect) {
//        // Drawing code
//        let path = createPath()
//        UIColor.black.setStroke()
//        UIColor.black.setFill()
//        path?.stroke()
//        path?.fill()
//    }
//
//    func createPath()->UIBezierPath? {
//        if points.count == 0 {
//            return nil
//        }
//        let path = UIBezierPath()
//        path.move(to: points.first!)
//        for (index,point) in points.enumerated() {
////            path.addCurve(to: point, controlPoint1: c1points[index], controlPoint2: c2points[index])
//            path.addLine(to: point)
//        }
//        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
//        path.addLine(to: CGPoint(x: 0, y: bounds.height))
//        path.close()
//        return path
//    }
}
