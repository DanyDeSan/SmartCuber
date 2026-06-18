//
//  Haptics.swift
//  SmartCuber
//
//  Thin wrapper over UIKit feedback generators for the timer ritual:
//  a rigid tick on arm, a success pop when ready, a heavy thud on stop.
//

import UIKit

enum Haptics {
  /// Fires when both prints register and the arm countdown begins.
  static func armTick(enabled: Bool) {
    guard enabled else { return }
    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
  }

  /// Fires when the timer becomes ready to start.
  static func ready(enabled: Bool) {
    guard enabled else { return }
    UINotificationFeedbackGenerator().notificationOccurred(.success)
  }

  /// Fires when the timer stops on a solve.
  static func stop(enabled: Bool) {
    guard enabled else { return }
    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
  }
}
