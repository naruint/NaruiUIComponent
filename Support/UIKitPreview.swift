//
//  UIKitPreview.swift
//  HanwhaLife
//
//  Created by 정재성 on 2020/12/08.
//

#if canImport(SwiftUI) && DEBUG

import UIKit
import SwiftUI

// MARK: - UIViewPreview

@available(iOS 13.0, *)
struct UIViewPreview<View: UIView>: UIViewRepresentable {
  let view: View

  init(_ builder: @escaping () -> View) {
    view = builder()
  }

  func makeUIView(context: Context) -> View {
    return view
  }

  func updateUIView(_ view: View, context: Context) {
  }

  @inlinable func onUpdate(_ updater: @escaping (View) -> Void) -> some SwiftUI.View {
    return _UpdatableUIViewPreview(view, updater: updater)
  }
}

// MARK: - UIViewPreview_UpdatableUIViewPreview

@available(iOS 13.0, *)
extension UIViewPreview {
  private struct _UpdatableUIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    let updater: (View) -> Void

    init(_ view: View, updater: @escaping (View) -> Void) {
      self.view = view
      self.updater = updater
    }

    func makeUIView(context: Context) -> View {
      return view
    }

    func updateUIView(_ uiView: View, context: Context) {
      updater(view)
    }
  }
}

// MARK: - UIViewControllerPreview

@available(iOS 13.0, *)
struct UIViewControllerPreview<ViewController: UIViewController>: View {
  private let _builder: () -> ViewController

  init(_ builder: @escaping () -> ViewController) {
    _builder = builder
  }

  var body: some View {
    _UIViewControllerRepresentation(_builder)
  }

  @inlinable func onUpdate(_ updater: @escaping (ViewController) -> Void) -> some SwiftUI.View {
    return _UpdatableUIViewControllerRepresentation(_builder, updater: updater)
  }
}

// MARK: - UIViewControllerPreview._UIViewControllerRepresentation

@available(iOS 13.0, *)
private struct _UIViewControllerRepresentation<ViewController: UIViewController>: UIViewControllerRepresentable {
  let viewController: ViewController

  init(_ builder: @escaping () -> ViewController) {
    viewController = builder()
  }

  func makeUIViewController(context: Context) -> ViewController {
    return viewController
  }

  func updateUIViewController(_ viewController: ViewController, context: Context) {
  }
}

// MARK: - _UpdatableUIViewControllerRepresentation

@available(iOS 13.0, *)
private struct _UpdatableUIViewControllerRepresentation<ViewController: UIViewController>: UIViewControllerRepresentable { // swiftlint:disable:this line_length
  let viewController: ViewController
  let updater: (ViewController) -> Void

  init(_ builder: @escaping () -> ViewController, updater: @escaping (ViewController) -> Void) {
    self.viewController = builder()
    self.updater = updater
  }

  func makeUIViewController(context: Context) -> ViewController {
    return viewController
  }

  func updateUIViewController(_ viewController: ViewController, context: Context) {
    updater(viewController)
  }
}

// MARK: - PreviewDevice

@available(iOS 13.0, *)
extension PreviewDevice {
  // swiftlint:disable identifier_name
  static let iPhone4s = PreviewDevice(rawValue: "iPhone 4s")
  static let iPhone5 = PreviewDevice(rawValue: "iPhone 5")
  static let iPhone5s = PreviewDevice(rawValue: "iPhone 5s")
  static let iPhone6 = PreviewDevice(rawValue: "iPhone 6")
  static let iPhone6Plus = PreviewDevice(rawValue: "iPhone 6 Plus")
  static let iPhone6s = PreviewDevice(rawValue: "iPhone 6s")
  static let iPhone6sPlus = PreviewDevice(rawValue: "iPhone 6s Plus")
  static let iPhone7 = PreviewDevice(rawValue: "iPhone 7")
  static let iPhone7Plus = PreviewDevice(rawValue: "iPhone 7 Plus")
  static let iPhone8 = PreviewDevice(rawValue: "iPhone 8")
  static let iPhone8Plus = PreviewDevice(rawValue: "iPhone 8 Plus")
  static let iPhoneX = PreviewDevice(rawValue: "iPhone X")
  static let iPhoneXs = PreviewDevice(rawValue: "iPhone Xs")
  static let iPhoneXsMax = PreviewDevice(rawValue: "iPhone Xs Max")
  static let iPhoneXr = PreviewDevice(rawValue: "iPhone Xʀ")
  static let iPhone11 = PreviewDevice(rawValue: "iPhone 11")
  static let iPhone11Pro = PreviewDevice(rawValue: "iPhone 11 Pro")
  static let iPhone11ProMax = PreviewDevice(rawValue: "iPhone 11 Pro Max")
  static let iPhone12mini = PreviewDevice(rawValue: "iPhone 12 mini")
  static let iPhone12 = PreviewDevice(rawValue: "iPhone 12")
  static let iPhone12Pro = PreviewDevice(rawValue: "iPhone 12 Pro")
  static let iPhone12ProMax = PreviewDevice(rawValue: "iPhone 12 Pro Max")
  static let iPhoneSE = PreviewDevice(rawValue: "iPhone SE (1st generation)")
  static let iPhoneSE_2nd = PreviewDevice(rawValue: "iPhone SE (2nd generation)")

  static let iPad2 = PreviewDevice(rawValue: "iPad 2")
  static let iPadRetina = PreviewDevice(rawValue: "iPad Retina")
  static let iPad_5th = PreviewDevice(rawValue: "iPad (5th generation)")
  static let iPad_6th = PreviewDevice(rawValue: "iPad (6th generation)")
  static let iPad_7th = PreviewDevice(rawValue: "iPad (7th generation)")
  static let iPadAir = PreviewDevice(rawValue: "iPad Air")
  static let iPadAir2 = PreviewDevice(rawValue: "iPad Air 2")
  static let iPadAir3 = PreviewDevice(rawValue: "iPad Air (3rd generation)")
  static let iPadMini2 = PreviewDevice(rawValue: "iPad mini 2")
  static let iPadMini3 = PreviewDevice(rawValue: "iPad mini 3")
  static let iPadMini4 = PreviewDevice(rawValue: "iPad mini 4")
  static let iPadMini5 = PreviewDevice(rawValue: "iPad mini (5th generation)")
  static let iPadPro_9_7_inch = PreviewDevice(rawValue: "iPad Pro (9.7-inch)")
  static let iPadPro_10_5_inch = PreviewDevice(rawValue: "iPad Pro (10.5-inch)")
  static let iPadPro_11_inch = PreviewDevice(rawValue: "iPad Pro (11-inch) (1st generation)")
  static let iPadPro_11_inch_2nd = PreviewDevice(rawValue: "iPad Pro (11-inch) (2nd generation)")
  static let iPadPro_12_9_inch = PreviewDevice(rawValue: "iPad Pro (12.9-inch)")
  static let iPadPro_12_9_inch_2nd = PreviewDevice(rawValue: "iPad Pro (12.9-inch) (2nd generation)")
  static let iPadPro_12_9_inch_3rd = PreviewDevice(rawValue: "iPad Pro (12.9-inch) (3rd generation)")
  static let iPadPro_12_9_inch_4th = PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)")

  static let appleTV = PreviewDevice(rawValue: "Apple TV")
  static let appleTV4K = PreviewDevice(rawValue: "Apple TV 4K")
  static let appleTV4k_1080p = PreviewDevice(rawValue: "Apple TV 4K (at 1080p)")

  static let appleWatch_38mm = PreviewDevice(rawValue: "Apple Watch - 38mm")
  static let appleWatch_42mm = PreviewDevice(rawValue: "Apple Watch - 42mm")
  static let appleWatch_series2_38mm = PreviewDevice(rawValue: "Apple Watch Series 2 - 38mm")
  static let appleWatch_series2_42mm = PreviewDevice(rawValue: "Apple Watch Series 2 - 42mm")
  static let appleWatch_series3_38mm = PreviewDevice(rawValue: "Apple Watch Series 3 - 38mm")
  static let appleWatch_series3_42mm = PreviewDevice(rawValue: "Apple Watch Series 3 - 42mm")
  static let appleWatch_series4_40mm = PreviewDevice(rawValue: "Apple Watch Series 4 - 40mm")
  static let appleWatch_series4_44mm = PreviewDevice(rawValue: "Apple Watch Series 4 - 44mm")
  static let appleWatch_series5_40mm = PreviewDevice(rawValue: "Apple Watch Series 5 - 40mm")
  static let appleWatch_series5_44mm = PreviewDevice(rawValue: "Apple Watch Series 5 - 44mm")
  // swiftlint:enable identifier_name
}

#endif
