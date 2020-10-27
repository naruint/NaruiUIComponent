//
//  NaruHorizontalSlideSelectViewQuestionModel.swift
//  UITest
//
//  Created by Changyeol Seo on 2020/10/23.
//

import Foundation
extension NaruHorizontalSlideSelectViewController {
    public struct QuestionModel: Codable {
        let title:String
        let desc:String
        let confirmtitle:String
    }
    
    public struct AnswerModel : Codable {
        let title:String
        let longTitle:String
        let subTitle:String
        let desc:String
    }

    public struct QuestionAnswersModel : Codable {
        let question:QuestionModel
        let answers:[AnswerModel]
    }
    
    public struct ViewModel: Codable {
        let datas:[QuestionAnswersModel]
        
        public static func makeModel(string:String)->ViewModel? {
            do {
                if let data = string.data(using: .utf8) {
                    return try JSONDecoder().decode(
                        ViewModel.self, from: data)
                }
            } catch {
                print("QuestionAnswersModel \(error.localizedDescription) : \(string)")
            }
            return nil
        }

    }
}
