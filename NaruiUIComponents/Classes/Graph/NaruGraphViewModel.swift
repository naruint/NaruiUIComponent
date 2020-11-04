//
//  NaruGraphViewModel.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/30.
//

import Foundation
extension NaruGraphView {
    public struct ViewModel : Codable {
        let values:[Float]
        
        public static func makeModel(string:String)->ViewModel? {
            do {
                if let data = string.data(using: .utf8) {
                    return try JSONDecoder().decode(
                        ViewModel.self, from: data)
                }
            } catch {
                print("error : \(error.localizedDescription) : \(string)")
            }
            return nil
        }
    }
}
