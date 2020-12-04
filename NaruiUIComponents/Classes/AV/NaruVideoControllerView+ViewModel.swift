//
//  NaruVideoControllerView+ViewModel.swift
//  NaruiUIComponents
//
//  Created by Changyeol Seo on 2020/12/04.
//

import Foundation
public extension NaruVideoControllerView {
    struct ViewModel {
        /** 영상 제목*/
        public let title:String
        /** 설명 시작시간*/
        public let startDescTime:TimeInterval
        /** 설명 종료시간*/
        public let endDescTime:TimeInterval
        /** 영상 URL*/
        public let url:URL
        /** 영상 미리보기 이미지 URL*/
        public let thumbnailURL:URL?
        public init(title:String, startDescTime:TimeInterval, endDescTime:TimeInterval, url:URL, thumbnailURL:URL?) {
            self.title = title
            self.startDescTime = startDescTime
            self.endDescTime = endDescTime
            self.url = url
            self.thumbnailURL = thumbnailURL
        }
    }
}
