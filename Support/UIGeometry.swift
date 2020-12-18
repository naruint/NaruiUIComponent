//
//  UIGeometry.swift
//  HanwhaLife
//
//  Created by 정재성 on 2020/12/08.
//

import UIKit.UIGeometry

// MARK: - UIEdgeInsets (Initializer)

extension UIEdgeInsets {
  @inlinable static func insets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }

  @inlinable static func top(_ top: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
  }

  @inlinable static func left(_ left: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
  }

  @inlinable static func bottom(_ bottom: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
  }

  @inlinable static func right(_ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: right)
  }

  @inlinable static func all(_ inset: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
  }

  @inlinable static func vertically(_ vertical: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: vertical, left: 0, bottom: vertical, right: 0)
  }

  @inlinable static func horizontally(_ horizontal: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: horizontal, bottom: 0, right: horizontal)
  }
}

// MARK: - UIEdgeInsets (Operator)

extension UIEdgeInsets {
  @inlinable static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: lhs.top + rhs.top,
      left: lhs.left + rhs.left,
      bottom: lhs.bottom + rhs.bottom,
      right: lhs.right + rhs.right
    )
  }

  @inlinable static func += (lhs: inout UIEdgeInsets, rhs: UIEdgeInsets) {
    lhs = lhs + rhs
  }

  @inlinable static func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: lhs.top - rhs.top,
      left: lhs.left - rhs.left,
      bottom: lhs.bottom - rhs.bottom,
      right: lhs.right - rhs.right
    )
  }

  @inlinable static func -= (lhs: inout UIEdgeInsets, rhs: UIEdgeInsets) {
    lhs = lhs - rhs
  }

  @inlinable static func * (lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: lhs.top * rhs,
      left: lhs.left * rhs,
      bottom: lhs.bottom * rhs,
      right: lhs.right * rhs
    )
  }

  @inlinable static func * (lhs: UIEdgeInsets, rhs: Int) -> UIEdgeInsets {
    return lhs * CGFloat(rhs)
  }

  @inlinable static func *= (lhs: inout UIEdgeInsets, rhs: CGFloat) {
    lhs = lhs * rhs
  }

  @inlinable static func *= (lhs: inout UIEdgeInsets, rhs: Int) {
    lhs = lhs * rhs
  }

  @inlinable func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: top.rounded(rule),
      left: left.rounded(rule),
      bottom: bottom.rounded(rule),
      right: right.rounded(rule)
    )
  }

  @inlinable mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) {
    self = UIEdgeInsets(
      top: top.rounded(rule),
      left: left.rounded(rule),
      bottom: bottom.rounded(rule),
      right: right.rounded(rule)
    )
  }
}

// MARK: - CGRect (Initializer)

extension CGRect {
  @inlinable static func rect(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
  }

  @inlinable static func rect(origin: CGPoint = .zero, size: CGSize = .zero) -> CGRect {
    return CGRect(origin: origin, size: size)
  }
}

// MARK: - CGRect (Property)

extension CGRect {
  @inlinable var topLeft: CGPoint {
    get { CGPoint(x: minX, y: minY) }
    set { self = CGRect(origin: newValue, size: size) }
  }

  @inlinable var topRight: CGPoint {
    get { CGPoint(x: maxX, y: minY) }
    set { self = CGRect(x: origin.x, y: newValue.y, width: width + (newValue.x - maxX), height: height) }
  }

  @inlinable var bottomLeft: CGPoint {
    get { CGPoint(x: minX, y: maxY) }
    set { self = CGRect(x: newValue.x, y: origin.y, width: width, height: height + (newValue.y - maxY)) }
  }

  @inlinable var bottomRight: CGPoint {
    get { CGPoint(x: maxX, y: maxY) }
    set {
      self = CGRect(
        x: origin.x,
        y: origin.y,
        width: width + (newValue.x - maxX),
        height: height + (newValue.y - maxY)
      )
    }
  }

  @inlinable var center: CGPoint {
    get { CGPoint(x: midX, y: midY) }
    set {
      self = CGRect(
        x: minX + (newValue.x - midX),
        y: minY + (newValue.y - midY),
        width: width,
        height: height
      )
    }
  }

  @inlinable func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> CGRect {
    return CGRect(origin: origin.rounded(rule), size: size.rounded(rule))
  }

  @inlinable mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) {
    self = CGRect(origin: origin.rounded(rule), size: size.rounded(rule))
  }
}

// MARK: - CGRect (Operator)

extension CGRect {
  @inlinable static func + (lhs: CGRect, rhs: CGPoint) -> CGRect {
    return CGRect(origin: lhs.origin + rhs, size: lhs.size)
  }

  @inlinable static func + (lhs: CGRect, rhs: CGSize) -> CGRect {
    return CGRect(origin: lhs.origin, size: lhs.size + rhs)
  }

  @inlinable static func += (lhs: inout CGRect, rhs: CGPoint) {
    lhs.origin = lhs.origin + rhs
  }

  @inlinable static func += (lhs: inout CGRect, rhs: CGSize) {
    lhs.size = lhs.size + rhs
  }

  @inlinable static func - (lhs: CGRect, rhs: CGPoint) -> CGRect {
    return CGRect(origin: lhs.origin - rhs, size: lhs.size)
  }

  @inlinable static func - (lhs: CGRect, rhs: CGSize) -> CGRect {
    return CGRect(origin: lhs.origin, size: lhs.size - rhs)
  }

  @inlinable static func -= (lhs: inout CGRect, rhs: CGPoint) {
    lhs.origin = lhs.origin - rhs
  }

  @inlinable static func -= (lhs: inout CGRect, rhs: CGSize) {
    lhs.size = lhs.size - rhs
  }
}

// MARK: - CGPoint (Initializer)

extension CGPoint {
  @inlinable static func point(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
    return CGPoint(x: x, y: y)
  }
}

// MARK: - CGPoint (Operator)

extension CGPoint {
  @inlinable static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(
      x: lhs.x + rhs.x,
      y: lhs.y + rhs.y
    )
  }

  @inlinable static func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(
      x: lhs.x + rhs,
      y: lhs.y + rhs
    )
  }

  @inlinable static func += (lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs + rhs
  }

  @inlinable static func += (lhs: inout CGPoint, rhs: CGFloat) {
    lhs = lhs + rhs
  }

  @inlinable static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(
      x: lhs.x - rhs.x,
      y: lhs.y - rhs.y
    )
  }

  @inlinable static func - (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(
      x: lhs.x - rhs,
      y: lhs.y - rhs
    )
  }

  @inlinable static func -= (lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs - rhs
  }

  @inlinable static func -= (lhs: inout CGPoint, rhs: CGFloat) {
    lhs = lhs - rhs
  }

  @inlinable static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(
      x: lhs.x * rhs,
      y: lhs.y * rhs
    )
  }

  @inlinable static func *= (lhs: inout CGPoint, rhs: CGFloat) {
    lhs = lhs * rhs
  }

  @inlinable func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> CGPoint {
    return CGPoint(x: x.rounded(rule), y: y.rounded(rule))
  }

  @inlinable mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) {
    self = CGPoint(x: x.rounded(rule), y: y.rounded(rule))
  }
}

// MARK: - CGSize (Initializer)

extension CGSize {
  @inlinable static func size(width: CGFloat = 0, height: CGFloat = 0) -> CGSize {
    return CGSize(width: width, height: height)
  }
}

// MARK: - CGSize (Operator)

extension CGSize {
  @inlinable static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(
      width: lhs.width + rhs.width,
      height: lhs.height + rhs.height
    )
  }

  @inlinable static func + (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(
      width: lhs.width + rhs,
      height: lhs.height + rhs
    )
  }

  @inlinable static func += (lhs: inout CGSize, rhs: CGSize) {
    lhs = lhs + rhs
  }

  @inlinable static func += (lhs: inout CGSize, rhs: CGFloat) {
    lhs = lhs + rhs
  }

  @inlinable static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(
      width: lhs.width - rhs.width,
      height: lhs.height - rhs.height
    )
  }

  @inlinable static func - (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(
      width: lhs.width - rhs,
      height: lhs.height - rhs
    )
  }

  @inlinable static func -= (lhs: inout CGSize, rhs: CGSize) {
    lhs = lhs - rhs
  }

  @inlinable static func -= (lhs: inout CGSize, rhs: CGFloat) {
    lhs = lhs - rhs
  }

  @inlinable static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(
      width: lhs.width * rhs,
      height: lhs.height * rhs
    )
  }

  @inlinable static func *= (lhs: inout CGSize, rhs: CGFloat) {
    lhs = lhs * rhs
  }

  @inlinable func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> CGSize {
    return CGSize(width: width.rounded(rule), height: height.rounded(rule))
  }

  @inlinable mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) {
    self = CGSize(width: width.rounded(rule), height: height.rounded(rule))
  }
}

// MARK: - UIGeometry (Hashable)

extension UIEdgeInsets: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(top)
    hasher.combine(left)
    hasher.combine(bottom)
    hasher.combine(right)
  }
}

extension CGPoint: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

extension CGSize: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(width)
    hasher.combine(height)
  }
}

extension CGRect: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(origin)
    hasher.combine(size)
  }
}
