//
//  Penalty.swift
//  SmartCuber
//

import Foundation

/// A WCA-style penalty applied to a solve.
enum Penalty: String, Codable, CaseIterable {
  case none
  case plusTwo
  case dnf

  /// Short label shown on the penalty controls (OK / +2 / DNF).
  var controlLabel: String {
    switch self {
    case .none: return "OK"
    case .plusTwo: return "+2"
    case .dnf: return "DNF"
    }
  }

  /// Seconds added to the raw time when computing the effective result.
  var addedSeconds: Double {
    self == .plusTwo ? 2 : 0
  }
}
