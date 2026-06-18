//
//  StatsViewModel.swift
//  SmartCuber
//
//  Read-only presenter for the Stats tab. Pure derived state, so it is a
//  value type rather than an `@Observable` (cf. the stateful TimerViewModel).
//

import Foundation
import SwiftData

struct StatsViewModel {
  let solves: [Solve]

  var isEmpty: Bool { solves.isEmpty }

  var statistics: SolveStatistics { SolveStatistics(solves: solves) }

  /// The session best, highlighted in mint in the history list.
  var bestSolveID: PersistentIdentifier? {
    solves
      .filter { !$0.isDNF }
      .min { $0.effectiveDuration < $1.effectiveDuration }?
      .persistentModelID
  }

  /// Splits the history into two balanced columns (newest first).
  var historyColumns: (left: Range<Int>, right: Range<Int>) {
    let half = Int((Double(solves.count) / 2).rounded(.up))
    return (0..<half, half..<solves.count)
  }

  /// The 1-based display number for a solve at a list position.
  func number(at position: Int) -> Int { solves.count - position }
}
