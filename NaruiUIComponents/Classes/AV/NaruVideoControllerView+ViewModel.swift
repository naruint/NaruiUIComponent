//
//  NaruVideoControllerView+ViewModel.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/12/04.
//

import Foundation
public extension NaruVideoControllerView {
    struct ViewModel {
        /** 영상 아이디*/
        public let id:String
        /** 영상 제목*/
        public let title:String
        /** 제생 시작 시각*/
        public let currentTime:TimeInterval
        /** 설명 시작시간*/
        public let startDescTime:TimeInterval
        /** 설명 종료시간*/
        public let endDescTime:TimeInterval
        /** 영상 URL*/
        public let url:URL
        /** 영상 미리보기 이미지 URL*/
        public let thumbnailURL:URL?
        public init(
            id:String,
            title:String,
            currentTime:TimeInterval,
            startDescTime:TimeInterval,
            endDescTime:TimeInterval,
            url:URL,
            thumbnailURL:URL?) {
            self.id = id
            self.title = title
            self.currentTime = currentTime
            self.startDescTime = startDescTime
            self.endDescTime = endDescTime
            self.url = url
            self.thumbnailURL = thumbnailURL
        }
    }
}
