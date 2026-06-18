//
//  Solve.swift
//  SmartCuber
//

import Foundation
import SwiftData

/// Represents a single Rubik's cube solve attempt.
@Model
final class Solve {
  var date: Date
  /// Solve duration in seconds. 0 means DNF/not yet recorded.
  var duration: Double
  /// Optional scramble string (e.g. "R U R' U'")
  var scramble: String?
  /// Optional notes (e.g. "PLL skip", "lucky cross")
  var notes: String?
  /// WCA-style penalty applied after the solve.
  var penalty: Penalty
  /// The puzzle this solve belongs to.
  var puzzle: Puzzle
  /// The session this solve was recorded in, if any.
  var session: Session?

  init(
    date: Date,
    duration: Double,
    scramble: String? = nil,
    notes: String? = nil,
    penalty: Penalty = .none,
    puzzle: Puzzle = .threeByThree
  ) {
    self.date = date
    self.duration = duration
    self.scramble = scramble
    self.notes = notes
    self.penalty = penalty
    self.puzzle = puzzle
  }

  /// Whether this solve was marked did-not-finish.
  var isDNF: Bool { penalty == .dnf }

  /// Raw duration plus any time penalty, in seconds. Used for ranking and
  /// averages. A DNF returns `.infinity` so it never counts as a best.
  var effectiveDuration: Double {
    if isDNF { return .infinity }
    return duration + penalty.addedSeconds
  }

  /// Human-readable duration, e.g. "1:23.45" or "45.67"
  var formattedDuration: String {
    guard duration > 0 else { return "DNF" }
    if duration >= 60 {
      let minutes = Int(duration) / 60
      let seconds = duration.truncatingRemainder(dividingBy: 60)
      return String(format: "%d:%05.2f", minutes, seconds)
    } else {
      return String(format: "%.2f", duration)
    }
  }

  /// Penalty-aware display string used across the timer, stats and solves
  /// screens — "DNF", a trailing "+" for a +2, or the plain time.
  var displayTime: String {
    switch penalty {
    case .dnf:
      return "DNF"

    case .plusTwo:
      return TimeFormatter.string(seconds: effectiveDuration) + "+"

    case .none:
      return TimeFormatter.string(seconds: duration)
    }
  }
}
