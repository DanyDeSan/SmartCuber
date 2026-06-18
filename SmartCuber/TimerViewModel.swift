//
//  TimerViewModel.swift
//  SmartCuber
//
//  Drives the timer ritual state machine and the running clock. Reactive
//  state via Observation, timing via async/await — no Combine, no SwiftUI.
//  See [[project_no_combine]].
//

import Foundation
import Observation

@MainActor
@Observable
final class TimerViewModel {
  private(set) var phase: TimerPhase = .idle
  /// Elapsed time of the current/last solve, in seconds.
  private(set) var elapsedSeconds: Double = 0
  private(set) var scramble: String
  private(set) var lastSolveWasPB = false

  var puzzle: Puzzle {
    didSet {
      guard puzzle != oldValue else { return }
      regenerateScramble()
    }
  }

  /// Records a finished solve. Returns whether it was a personal best.
  var onSolveCompleted: ((_ duration: Double, _ scramble: String, _ puzzle: Puzzle) -> Bool)?

  @ObservationIgnored private let settings: TimerSettings
  @ObservationIgnored private var armTask: Task<Void, Never>?
  @ObservationIgnored private var clockTask: Task<Void, Never>?
  @ObservationIgnored private var runStart: Date?

  init(settings: TimerSettings, puzzle: Puzzle = .threeByThree) {
    self.settings = settings
    self.puzzle = puzzle
    self.scramble = ScrambleGenerator.generate(for: puzzle)
  }

  // ── input from the press surface ──────────────────────────
  /// A finger touched the timer surface.
  func pressBegan() {
    switch phase {
    case .idle:
      beginHolding()

    case .stopped:
      prepareNextSolve()
      beginHolding()

    case .running:
      stopClock()

    case .holding, .ready:
      break
    }
  }

  /// A finger lifted from the timer surface.
  func pressEnded() {
    switch phase {
    case .holding:
      cancelArm()
      phase = .idle

    case .ready:
      startClock()

    case .idle, .running, .stopped:
      break
    }
  }

  /// Generates a fresh scramble (overflow menu → "New scramble").
  func regenerateScramble() {
    scramble = ScrambleGenerator.generate(for: puzzle)
  }

  // ── transitions ───────────────────────────────────────────
  private func beginHolding() {
    phase = .holding
    Haptics.armTick(enabled: settings.hapticsEnabled)
    armTask = Task { [weak self] in
      guard let self else { return }
      let hold = self.settings.holdToArmSeconds
      try? await Task.sleep(for: .seconds(hold))
      guard !Task.isCancelled, self.phase == .holding else { return }
      self.phase = .ready
      Haptics.ready(enabled: self.settings.hapticsEnabled)
    }
  }

  private func startClock() {
    cancelArm()
    phase = .running
    elapsedSeconds = 0
    let start = Date()
    runStart = start
    clockTask = Task { [weak self] in
      while !Task.isCancelled {
        self?.elapsedSeconds = Date().timeIntervalSince(start)
        try? await Task.sleep(for: .milliseconds(16))
      }
    }
  }

  private func stopClock() {
    clockTask?.cancel()
    clockTask = nil
    if let runStart {
      elapsedSeconds = Date().timeIntervalSince(runStart)
    }
    runStart = nil
    phase = .stopped
    Haptics.stop(enabled: settings.hapticsEnabled)
    lastSolveWasPB = onSolveCompleted?(elapsedSeconds, scramble, puzzle) ?? false
  }

  private func prepareNextSolve() {
    elapsedSeconds = 0
    lastSolveWasPB = false
    regenerateScramble()
  }

  private func cancelArm() {
    armTask?.cancel()
    armTask = nil
  }
}
