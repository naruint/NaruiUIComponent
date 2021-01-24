//
//  NaruTimmer.swift
//  UITest
//
//  Created by Changyeol Seo on 2020/10/20.
//

import Foundation
public extension Notification.Name {
    static let naruTimmerDidUpdated = Notification.Name(rawValue: "naruTimmerDidUpdated_observer")
}

public class NaruTimmer {
    static let audioTimer = NaruTimmer()
    static let videoTimer = NaruTimmer()
    
    public init() {
        
    }
    public enum TimeStempType {
        case start
        case stop
    }
    
    public struct TimeStemp {
        public let date:Date
        public let type:TimeStempType
        public init(date:Date, type:TimeStempType) {
            self.date = date
            self.type = type
        }
    }
    
    private var timeStemps:[TimeStemp] = []
    /** 타이머 시작*/
    public func start() {
        if timeStemps.last?.type == .start {
            return
        }
        timeStemps.append(TimeStemp(date: Date(), type: .start))
        noti()
    }
    
    /** 타이머 멈춤*/
    public func stop() {
        if timeStemps.last?.type == .start {
            timeStemps.append(TimeStemp(date: Date(), type: .stop))
        }
    }

    /** 타이머 리셋*/
    public func reset() {
        timeStemps.removeAll()
    }
    
    var timeResult:TimeInterval {
        var start:TimeInterval = 0
        var result:TimeInterval = 0
        
        for stemp in timeStemps {
            let i = stemp.date.timeIntervalSince1970
            switch stemp.type {
            case .start:
                start = i
            case .stop:
                result += (i - start)
            }
            
            if timeStemps.last?.type == .start && stemp.date == timeStemps.last?.date {
                result += (Date().timeIntervalSince1970 - start)
            }
        }
        return result
    }
    
    private func noti() {
        if timeStemps.last?.type == .start {
            NotificationCenter.default.post(name: .naruTimmerDidUpdated, object: timeResult)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                self?.noti()
            }
        }
    }
}
