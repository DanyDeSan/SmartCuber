//
//  SolveRecorder.swift
//  SmartCuber
//
//  Persists finished solves and reports whether each is a personal best.
//  Kept separate from the timer view model so the timer stays free of
//  SwiftData.
//

import Foundation
import SwiftData

enum SolveRecorder {
  /// Records a completed solve in the current session and returns whether it
  /// beat the previous best for that puzzle.
  @discardableResult
  static func record(
    duration: Double,
    scramble: String,
    puzzle: Puzzle,
    in context: ModelContext
  ) -> Bool {
    let previousBest = bestEffectiveDuration(for: puzzle, in: context)
    let isPersonalBest = duration < previousBest

    let solve = Solve(
      date: .now, duration: duration, scramble: scramble, puzzle: puzzle)
    solve.session = currentSession(in: context)
    context.insert(solve)
    try? context.save()

    return isPersonalBest
  }

  /// The best effective time recorded for a puzzle, or `.infinity` if none.
  private static func bestEffectiveDuration(
    for puzzle: Puzzle, in context: ModelContext
  ) -> Double {
    let solves = (try? context.fetch(FetchDescriptor<Solve>())) ?? []
    return solves
      .filter { $0.puzzle == puzzle && !$0.isDNF }
      .map(\.effectiveDuration)
      .min() ?? .infinity
  }

  /// The most recently created session, creating a "Casual" one if needed.
  private static func currentSession(in context: ModelContext) -> Session {
    let descriptor = FetchDescriptor<Session>(
      sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
    if let existing = try? context.fetch(descriptor).first {
      return existing
    }
    let session = Session(name: "Casual")
    context.insert(session)
    return session
  }
}
