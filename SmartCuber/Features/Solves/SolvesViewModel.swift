//
//  SolvesViewModel.swift
//  SmartCuber
//
//  Presenter + actions for the Solves tab. Derived state is computed from the
//  query; mutations take the `ModelContext` so the type stays a value.
//

import Foundation
import SwiftData

struct SolvesViewModel {
  let solves: [Solve]
  let selectedSolveID: PersistentIdentifier?

  var isEmpty: Bool { solves.isEmpty }

  /// The selected solve, falling back to the most recent one.
  var selected: Solve? {
    solves.first { $0.persistentModelID == selectedSolveID } ?? solves.first
  }

  /// The 1-based display number for a solve at a list position.
  func number(at position: Int) -> Int { solves.count - position }

  /// The 1-based display number for a specific solve.
  func number(for solve: Solve) -> Int? {
    guard let index = solves.firstIndex(where: {
      $0.persistentModelID == solve.persistentModelID
    }) else { return nil }
    return solves.count - index
  }

  // ── actions ───────────────────────────────────────────────
  func setPenalty(_ solve: Solve, to penalty: Penalty, in context: ModelContext) {
    solve.penalty = penalty
    try? context.save()
  }

  func delete(_ solve: Solve, coordinator: AppCoordinator, in context: ModelContext) {
    if coordinator.selectedSolveID == solve.persistentModelID {
      coordinator.selectedSolveID = nil
    }
    context.delete(solve)
    try? context.save()
  }
}
