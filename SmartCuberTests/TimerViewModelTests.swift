//
//  TimerViewModelTests.swift
//  SmartCuberTests
//

import Foundation
@testable import SmartCuber
import Testing

@MainActor
struct TimerViewModelTests {
  private func makeSettings(inspectionEnabled: Bool) throws -> TimerSettings {
    let defaults = try #require(UserDefaults(suiteName: "TimerViewModelTests-\(UUID())"))
    let settings = TimerSettings(defaults: defaults)
    settings.holdToArmSeconds = 0.02
    settings.inspectionEnabled = inspectionEnabled
    return settings
  }

  /// Touches both prints and waits long enough for the hold-to-arm timer
  /// (20ms in these tests) to complete, landing in `.ready`.
  private func arm(_ model: TimerViewModel) async {
    model.pressBegan()
    try? await Task.sleep(for: .milliseconds(60))
  }

  @Test func inspectionDisabledStartsClockDirectlyOnRelease() async throws {
    let model = TimerViewModel(settings: try makeSettings(inspectionEnabled: false))

    await arm(model)
    #expect(model.phase == .ready)
    model.pressEnded()
    #expect(model.phase == .running)
  }

  @Test func inspectionEnabledEntersInspectingOnFirstRelease() async throws {
    let model = TimerViewModel(settings: try makeSettings(inspectionEnabled: true))

    await arm(model)
    model.pressEnded()
    #expect(model.phase == .inspecting)
  }

  @Test func reArmingFromInspectingThenReleasingStartsTheClock() async throws {
    let model = TimerViewModel(settings: try makeSettings(inspectionEnabled: true))

    await arm(model)
    model.pressEnded()
    #expect(model.phase == .inspecting)

    await arm(model)
    #expect(model.phase == .ready)
    model.pressEnded()
    #expect(model.phase == .running)
  }

  @Test func releasingEarlyDuringReArmReturnsToInspectingNotIdle() async throws {
    let model = TimerViewModel(settings: try makeSettings(inspectionEnabled: true))

    await arm(model)
    model.pressEnded()
    #expect(model.phase == .inspecting)

    model.pressBegan()
    #expect(model.phase == .holding)
    model.pressEnded()
    #expect(model.phase == .inspecting)
  }

  @Test func inspectionPenaltyThresholds() {
    #expect(TimerViewModel.inspectionPenalty(forElapsedSeconds: 5) == .none)
    #expect(TimerViewModel.inspectionPenalty(forElapsedSeconds: 14.99) == .none)
    #expect(TimerViewModel.inspectionPenalty(forElapsedSeconds: 15) == .plusTwo)
    #expect(TimerViewModel.inspectionPenalty(forElapsedSeconds: 16.99) == .plusTwo)
    #expect(TimerViewModel.inspectionPenalty(forElapsedSeconds: 17) == .dnf)
    #expect(TimerViewModel.inspectionPenalty(forElapsedSeconds: 30) == .dnf)
  }
}
