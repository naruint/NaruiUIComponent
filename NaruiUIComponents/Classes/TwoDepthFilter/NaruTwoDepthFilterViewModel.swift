//
//  NaruTwoDepthFilterViewModel.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/27.
//

import Foundation
extension NaruTwoDepthFilterView {
    
    public struct SubFilterModel:Codable {
        let title:String
        let value:Int
    }
    
    public struct FilterModel:Codable {
        let title:String
        let subtitles:[SubFilterModel]
    }
        
    public struct ViewModel:Codable {
        let filters:[FilterModel]
        
        public static func makeModel(string:String)->ViewModel? {
            do {
                if let data = string.data(using: .utf8) {
                    return try JSONDecoder().decode(
                        ViewModel.self, from: data)
                }
            } catch {
                // print("error : \(error.localizedDescription) : \(string)")
            }
            return nil
        }
    }
}
