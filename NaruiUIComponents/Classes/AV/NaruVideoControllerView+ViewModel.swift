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
        /** 미이어 구분코드*/
        public let mdiaDvcd:String
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
            midaDvcd:String,
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
            self.mdiaDvcd = midaDvcd
        }
    }
    
    struct ResultModel {
        /** 영상 아이디*/
        public let id:String
        /** 미디어dvcd*/
        public let midaDvcd:String
        /** 영상 제목*/
        public let title:String
        /** 감상시간*/
        public let watchTime:TimeInterval
        /** 마지막 타임라인 시각*/
        public let currentTime:TimeInterval
        /** 동영상 제생 시간*/
        public let duration:TimeInterval
        /** 끝까지 봤나?*/
        public var isWatchFinish:Bool {
            currentTime > duration - 1
        }
        public init(
            id:String,
            midaDvcd:String,
            title:String,
            watchTime:TimeInterval,
            currentTime:TimeInterval,
            duration:TimeInterval
        ) {
            self.id = id
            self.title = title
            self.watchTime = watchTime
            self.currentTime = currentTime
            self.duration = duration
            self.midaDvcd = midaDvcd
        }
    }
}
