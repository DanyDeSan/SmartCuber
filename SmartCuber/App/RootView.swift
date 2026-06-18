//
//  RootView.swift
//  SmartCuber
//
//  The app's root. Owns the coordinator, settings and timer view model, and
//  hosts the four tabs in a native `TabView` (Liquid Glass tab bar). Each
//  feature screen fetches its own data; the root only wires shared state.
//

import SwiftData
import SwiftUI

struct RootView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Session.createdAt, order: .reverse) private var sessions: [Session]

  @State private var coordinator = AppCoordinator()
  @State private var settings: TimerSettings
  @State private var timerModel: TimerViewModel

  init() {
    let settings = TimerSettings()
    _settings = State(initialValue: settings)
    _timerModel = State(initialValue: TimerViewModel(settings: settings))
  }

  private var sessionName: String { sessions.first?.name ?? "Casual" }

  var body: some View {
    @Bindable var coordinator = coordinator
    TabView(selection: $coordinator.selectedTab) {
      Tab(AppTab.timer.title, systemImage: AppTab.timer.systemImage, value: AppTab.timer) {
        TimerScreenView(
          model: timerModel,
          settings: settings,
          sessionName: sessionName,
          onDeleteLast: deleteLastSolve)
      }
      Tab(AppTab.stats.title, systemImage: AppTab.stats.systemImage, value: AppTab.stats) {
        StatsScreenView(sessionName: sessionName, puzzleLabel: timerModel.puzzle.label)
      }
      Tab(AppTab.solves.title, systemImage: AppTab.solves.systemImage, value: AppTab.solves) {
        SolvesScreenView(sessionName: sessionName, coordinator: coordinator)
      }
      Tab(AppTab.settings.title, systemImage: AppTab.settings.systemImage, value: AppTab.settings) {
        SettingsScreenView(settings: settings, sessionCount: max(sessions.count, 1))
      }
    }
    .tint(Theme.mint)
    .preferredColorScheme(.dark)
    .onAppear(perform: configure)
  }

  // ── wiring ────────────────────────────────────────────────
  private func configure() {
    timerModel.onSolveCompleted = { duration, scramble, puzzle in
      SolveRecorder.record(
        duration: duration, scramble: scramble, puzzle: puzzle, in: modelContext)
    }
  }

  /// Deletes the most recent solve (timer overflow → "Delete last solve").
  private func deleteLastSolve() {
    var descriptor = FetchDescriptor<Solve>(sortBy: [SortDescriptor(\.date, order: .reverse)])
    descriptor.fetchLimit = 1
    guard let last = try? modelContext.fetch(descriptor).first else { return }
    if coordinator.selectedSolveID == last.persistentModelID {
      coordinator.selectedSolveID = nil
    }
    modelContext.delete(last)
    try? modelContext.save()
  }
}
