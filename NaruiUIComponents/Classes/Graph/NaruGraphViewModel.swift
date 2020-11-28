//
//  NaruGraphViewModel.swift
//  FBSnapshotTestCase
//
//  Created by Changyeol Seo on 2020/10/30.
//

import Foundation
extension NaruGraphView {
    struct Date : Codable {
        let year:Int
        let month:Int
        let day:Int
        var date:Foundation.Date? {
            return "\(year)_\(month)_\(day)".getDate(format: "yyyy_M_d")
        }
        var dayWeak:Int {
            if let d = date {
                let calendar = Calendar.current
                let component = calendar.component(.weekday, from: d)
                return component
            }
            return 0
        }
        var dayWeakString:String {
            switch dayWeak {
            case 0: return "S"
            case 1: return "M"
            case 2: return "T"
            case 3: return "W"
            case 4: return "T"
            case 5: return "F"
            case 6: return "S"
            default: return "S"
            }
        }
    }
    
    struct Data : Codable {
        let value:Float
        let date:Date
    }
    
    public struct ViewModel : Codable {
        let values:[Data]
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
