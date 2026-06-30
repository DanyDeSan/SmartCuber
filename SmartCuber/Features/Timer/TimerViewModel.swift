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
  /// Elapsed time of the current WCA inspection, in seconds. Keeps ticking
  /// through a re-arm attempt so the penalty reflects the moment the solve
  /// actually starts, not the moment the cuber first touches to re-arm.
  private(set) var inspectionSeconds: Double = 0
  private(set) var scramble: String
  private(set) var lastSolveWasPB = false

  var puzzle: Puzzle {
    didSet {
      guard puzzle != oldValue else { return }
      regenerateScramble()
    }
  }

  /// Records a finished solve. Returns whether it was a personal best.
  var onSolveCompleted:
    ((_ duration: Double, _ scramble: String, _ puzzle: Puzzle, _ penalty: Penalty) -> Bool)?

  @ObservationIgnored private let settings: TimerSettings
  @ObservationIgnored private var armTask: Task<Void, Never>?
  @ObservationIgnored private var clockTask: Task<Void, Never>?
  @ObservationIgnored private var inspectionTask: Task<Void, Never>?
  @ObservationIgnored private var runStart: Date?
  @ObservationIgnored private var isInspectionActive = false
  @ObservationIgnored private var pendingPenalty: Penalty = .none

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

    case .inspecting:
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
      phase = isInspectionActive ? .inspecting : .idle

    case .ready:
      if isInspectionActive {
        startClock()
      } else if settings.inspectionEnabled {
        beginInspecting()
      } else {
        startClock()
      }

    case .idle, .inspecting, .running, .stopped:
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
    pendingPenalty = inspectionPenalty()
    cancelArm()
    cancelInspection()
    phase = .running
    elapsedSeconds = 0
    let start = Date()
    runStart = start
    clockTask = Task { [weak self] in
      while !Task.isCancelled {
        guard let self else { break }
        self.elapsedSeconds = Date().timeIntervalSince(start)
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
    let penalty = pendingPenalty
    pendingPenalty = .none
    lastSolveWasPB = onSolveCompleted?(elapsedSeconds, scramble, puzzle, penalty) ?? false
  }

  private func prepareNextSolve() {
    elapsedSeconds = 0
    lastSolveWasPB = false
    cancelInspection()
    regenerateScramble()
  }

  private func cancelArm() {
    armTask?.cancel()
    armTask = nil
  }

  // ── WCA inspection ────────────────────────────────────────
  /// Starts the 15-second inspection countdown after the first arm
  /// completes. Touching both prints again re-arms; the *next* release
  /// starts the solve clock for real (see `pressEnded()`/`startClock()`).
  private func beginInspecting() {
    isInspectionActive = true
    phase = .inspecting
    let start = Date()
    inspectionTask = Task { [weak self] in
      while !Task.isCancelled {
        guard let self else { break }
        self.inspectionSeconds = Date().timeIntervalSince(start)
        try? await Task.sleep(for: .milliseconds(16))
      }
    }
  }

  private func cancelInspection() {
    inspectionTask?.cancel()
    inspectionTask = nil
    isInspectionActive = false
    inspectionSeconds = 0
  }

  private func inspectionPenalty() -> Penalty {
    guard isInspectionActive else { return .none }
    return Self.inspectionPenalty(forElapsedSeconds: inspectionSeconds)
  }

  /// The WCA-style penalty earned from an inspection of the given length:
  /// none under 15s, +2 between 15–17s, DNF beyond 17s. A pure function so
  /// the boundary thresholds are directly unit-testable without waiting on
  /// real elapsed time.
  static func inspectionPenalty(forElapsedSeconds seconds: Double) -> Penalty {
    if seconds >= 17 { return .dnf }
    if seconds >= 15 { return .plusTwo }
    return .none
  }
}
