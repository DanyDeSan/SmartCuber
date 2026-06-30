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
  /// beat the previous best for that puzzle. A DNF never counts as a best.
  @discardableResult
  static func record(
    duration: Double,
    scramble: String,
    puzzle: Puzzle,
    penalty: Penalty = .none,
    in context: ModelContext
  ) -> Bool {
    let previousBest = bestEffectiveDuration(for: puzzle, in: context)

    let solve = Solve(
      date: .now, duration: duration, scramble: scramble, penalty: penalty, puzzle: puzzle)
    let isPersonalBest = solve.effectiveDuration < previousBest
    solve.session = currentSession(in: context)
    context.insert(solve)
    try? context.save()

    return isPersonalBest
  }

  /// The best effective time recorded for a puzzle, or `.infinity` if none.
  private static func bestEffectiveDuration(
    for puzzle: Puzzle, in context: ModelContext
  ) -> Double {
    // Filter in memory: SwiftData `#Predicate` does not reliably match on the
    // Codable `puzzle` / `penalty` enums at the store level (a predicate fetch
    // returns no rows, which would make every solve look like a PB). The solve
    // count per session stays small, so an in-memory scan is fine.
    let solves = (try? context.fetch(FetchDescriptor<Solve>())) ?? []
    return solves
      .filter { $0.puzzle == puzzle && !$0.isDNF }
      .map(\.effectiveDuration)
      .min() ?? .infinity
  }

  /// The session marked active, falling back to the most recently created
  /// one (promoting it to active) and lazily creating a "Casual" session if
  /// none exist yet. The fallback keeps pre-Sessions-management installs
  /// behaving exactly as before until the cuber explicitly picks a session.
  private static func currentSession(in context: ModelContext) -> Session {
    let descriptor = FetchDescriptor<Session>(
      sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
    let sessions = (try? context.fetch(descriptor)) ?? []
    if let active = sessions.first(where: \.isActive) {
      return active
    }
    if let mostRecent = sessions.first {
      mostRecent.isActive = true
      return mostRecent
    }
    let session = Session(name: "Casual", isActive: true)
    context.insert(session)
    return session
  }
}
