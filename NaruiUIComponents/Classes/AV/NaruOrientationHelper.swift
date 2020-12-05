//
//  OrientationHelper.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/12/04.
//

import Foundation
import UIKit
/** 기기 방향 전환 해주는 클래스.
 Appdelegate 에 다음 코드 추가
 func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
     return NaruOrientationHelper.shared.orientationLock
 }
 */
public class NaruOrientationHelper {
    public static let shared = NaruOrientationHelper()
    public var orientationLock = UIInterfaceOrientationMask.portrait
    
    public func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        orientationLock = orientation
    }
    
    public func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
