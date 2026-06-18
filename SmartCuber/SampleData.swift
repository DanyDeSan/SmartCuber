//
//  SampleData.swift
//  SmartCuber
//
//  Seeds a populated "Casual" session on first launch so the timer, stats
//  and solves tabs look like the design instead of an empty store.
//

import Foundation
import SwiftData

enum SampleData {
  /// One seeded solve: raw seconds, minutes-ago and an optional penalty.
  private struct Seed {
    let duration: Double
    let minutesAgo: Int
    var penalty: Penalty = .none
  }

  /// The seeded "Casual" session, newest first.
  private static let seeds: [Seed] = [
    Seed(duration: 9.76, minutesAgo: 2),
    Seed(duration: 11.02, minutesAgo: 4),
    Seed(duration: 13.11, minutesAgo: 6, penalty: .plusTwo),
    Seed(duration: 10.34, minutesAgo: 9),
    Seed(duration: 12.45, minutesAgo: 12),
    Seed(duration: 9.98, minutesAgo: 15),
    Seed(duration: 11.89, minutesAgo: 18),
    Seed(duration: 10.76, minutesAgo: 21),
    Seed(duration: 12.03, minutesAgo: 24),
    Seed(duration: 11.25, minutesAgo: 27),
    Seed(duration: 9.87, minutesAgo: 31),
    Seed(duration: 13.54, minutesAgo: 34),
    Seed(duration: 10.51, minutesAgo: 38),
    Seed(duration: 11.47, minutesAgo: 41)
  ]

  /// Inserts the sample session if the store has no sessions yet.
  static func seedIfNeeded(in context: ModelContext) {
    let existing = (try? context.fetchCount(FetchDescriptor<Session>())) ?? 0
    guard existing == 0 else { return }

    let session = Session(name: "Casual")
    context.insert(session)

    let now = Date()
    for seed in seeds {
      let solve = Solve(
        date: now.addingTimeInterval(Double(-seed.minutesAgo) * 60),
        duration: seed.duration,
        scramble: ScrambleGenerator.generate(for: .threeByThree),
        penalty: seed.penalty
      )
      solve.session = session
      context.insert(solve)
    }

    try? context.save()
  }
}
