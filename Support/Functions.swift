//
//  Functions.swift
//  HanwhaLife
//
//  Created by 정재성 on 2020/12/08.
//

@inlinable func clamp<T>(_ value: T, min minValue: T, max maxValue: T) -> T where T: Comparable {
  return max(minValue, min(value, maxValue))
}

@inlinable func memoize<T, U>(_ f: @escaping (T) -> U) -> (T) -> U where T: Hashable {
  var memo: [T: U] = [:]
  return { x in
    if let r = memo[x] {
      return r
    }
    let r = f(x)
    memo[x] = r
    return r
  }
}

@inlinable func memoize<T0, T1, U>(_ f: @escaping (T0, T1) -> U) -> (T0, T1) -> U where T0: Hashable, T1: Hashable {
  var memo: [Int: U] = [:]
  return { t0, t1 in
    let hash = Hasher {
      $0.combine(t0)
      $0.combine(t1)
    }
    .finalize()

    if let r = memo[hash] {
      return r
    }
    let r = f(t0, t1)
    memo[hash] = r
    return r
  }
}

@inlinable func memoize<T0, T1, T2, U> (_ f: @escaping (T0, T1, T2) -> U) -> (T0, T1, T2) -> U where T0: Hashable, T1: Hashable, T2: Hashable {
  var memo: [Int: U] = [:]
  return { t0, t1, t2 in
    let hash = Hasher {
      $0.combine(t0)
      $0.combine(t1)
      $0.combine(t2)
    }
    .finalize()

    if let r = memo[hash] {
      return r
    }
    let r = f(t0, t1, t2)
    memo[hash] = r
    return r
  }
}

@inlinable func memoize<T0, T1, T2, T3, U> (_ f: @escaping (T0, T1, T2, T3) -> U) -> (T0, T1, T2, T3) -> U where T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable {
  var memo: [Int: U] = [:]
  return { t0, t1, t2, t3 in
    let hash = Hasher {
      $0.combine(t0)
      $0.combine(t1)
      $0.combine(t2)
      $0.combine(t3)
    }
    .finalize()

    if let r = memo[hash] {
      return r
    }
    let r = f(t0, t1, t2, t3)
    memo[hash] = r
    return r
  }
}

@inlinable func memoize<T0, T1, T2, T3, T4, U> (_ f: @escaping (T0, T1, T2, T3, T4) -> U) -> (T0, T1, T2, T3, T4) -> U where T0: Hashable, T1: Hashable, T2: Hashable, T3: Hashable, T4: Hashable {
  var memo: [Int: U] = [:]
  return { t0, t1, t2, t3, t4 in
    let hash = Hasher {
      $0.combine(t0)
      $0.combine(t1)
      $0.combine(t2)
      $0.combine(t3)
      $0.combine(t4)
    }
    .finalize()

    if let r = memo[hash] {
      return r
    }
    let r = f(t0, t1, t2, t3, t4)
    memo[hash] = r
    return r
  }
}

extension Hasher {
  public init(_ combiner: (inout Hasher) -> Void) {
    self.init()
    combiner(&self)
  }
}
