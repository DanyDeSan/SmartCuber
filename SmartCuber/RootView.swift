//
//  RootView.swift
//  SmartCuber
//
//  The app's root. Owns the coordinator, settings and timer view model, and
//  renders the selected tab. Replaces the original split-view ContentView.
//

import SwiftData
import SwiftUI

struct RootView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Solve.date, order: .reverse) private var solves: [Solve]
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
  private var statistics: SolveStatistics { SolveStatistics(solves: solves) }

  var body: some View {
    ZStack {
      Theme.background.ignoresSafeArea()
      screen
    }
    .preferredColorScheme(.dark)
    .onAppear(perform: configure)
  }

  @ViewBuilder private var screen: some View {
    switch coordinator.selectedTab {
    case .timer:
      TimerScreenView(
        model: timerModel,
        settings: settings,
        sessionName: sessionName,
        onSelectTab: coordinator.select,
        onDeleteLast: deleteLastSolve)

    case .stats:
      StatsScreenView(
        solves: solves,
        stats: statistics,
        sessionName: sessionName,
        puzzleLabel: timerModel.puzzle.label,
        onSelectTab: coordinator.select)

    case .solves:
      SolvesScreenView(
        solves: solves,
        sessionName: sessionName,
        selectedSolveID: coordinator.selectedSolveID,
        onSelect: coordinator.select,
        onSetPenalty: setPenalty,
        onDelete: delete,
        onSelectTab: coordinator.select)

    case .settings:
      SettingsScreenView(
        settings: settings,
        sessionCount: max(sessions.count, 1),
        onSelectTab: coordinator.select)
    }
  }

  // ── wiring ────────────────────────────────────────────────
  private func configure() {
    SampleData.seedIfNeeded(in: modelContext)
    timerModel.onSolveCompleted = { duration, scramble, puzzle in
      SolveRecorder.record(
        duration: duration, scramble: scramble, puzzle: puzzle, in: modelContext)
    }
  }

  // ── mutations ─────────────────────────────────────────────
  private func setPenalty(_ solve: Solve, _ penalty: Penalty) {
    solve.penalty = penalty
    try? modelContext.save()
  }

  private func delete(_ solve: Solve) {
    if coordinator.selectedSolveID == solve.persistentModelID {
      coordinator.selectedSolveID = nil
    }
    modelContext.delete(solve)
    try? modelContext.save()
  }

  private func deleteLastSolve() {
    guard let last = solves.first else { return }
    delete(last)
  }
}
