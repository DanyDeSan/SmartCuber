//
//  RelativeTime.swift
//  SmartCuber
//
//  Compact "time ago" labels ("now", "2m", "3h", "1d") for solve lists,
//  matching the terse style of the design's mock data.
//

import Foundation

enum RelativeTime {
  static func label(for date: Date, relativeTo reference: Date = .now) -> String {
    let seconds = max(0, reference.timeIntervalSince(date))
    switch seconds {
    case ..<45:
      return "now"

    case ..<3600:
      return "\(Int((seconds / 60).rounded()))m"

    case ..<86_400:
      return "\(Int(seconds / 3600))h"

    default:
      return "\(Int(seconds / 86_400))d"
    }
  }
}
