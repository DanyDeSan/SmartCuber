//
//  TimerPhase.swift
//  SmartCuber
//
//  The five states of the two-thumb timer ritual.
//

import Foundation

enum TimerPhase: Equatable {
  /// Waiting. Prints dim, hint reads "Hold both prints to start".
  case idle
  /// Both prints held, arm countdown running. Prints + wash turn red.
  case holding
  /// Armed. Prints + wash turn mint, hint reads "Release to start".
  case ready
  /// WCA inspection running (no prints held). Touching both prints again
  /// re-arms — the next release starts the solve clock for real.
  case inspecting
  /// Clock running. Chrome dims, prints become stop targets.
  case running
  /// Stopped on a result. May be a personal best.
  case stopped

  /// True while at least one print is registered.
  var isPressed: Bool {
    self == .holding || self == .ready
  }
}
