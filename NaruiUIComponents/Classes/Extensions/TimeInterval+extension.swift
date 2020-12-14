//
//  TimeInterval+extension.swift
//  lmhs
//
//  Created by Changyeol Seo on 2020/11/30.
//

import Foundation
public extension TimeInterval {
    /** 분, 초 포메팅으로 변환 리턴 */
    var formatted_ms_String:String? {
        makeString(units: [.minute, .second])
    }

    /** 시분, 초 포메팅으로 변환 리턴 */
    var formatted_hms_String:String? {
        makeString(units: [.hour, .second])
    }

    /** 시분 포메팅으로 변환 리턴 */
    var formatted_hm_String:String? {
        makeString(units: [.hour, .minute])
    }
    
    func makeString(units:NSCalendar.Unit)->String? {
        if self.isNaN {
            return nil
        }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self)
    }

}
