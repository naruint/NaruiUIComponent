//
//  Then.swift
//  HanwhaLife
//
//  Created by 정재성 on 2020/12/08.
//

import Foundation

protocol Then {
}

extension Then where Self: AnyObject {
  @inlinable func then(_ closure: (Self) throws -> Void) rethrows -> Self {
    try closure(self)
    return self
  }
}

extension NSObject: Then {}
