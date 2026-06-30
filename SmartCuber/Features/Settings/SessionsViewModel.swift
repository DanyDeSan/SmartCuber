//
//  SessionsViewModel.swift
//  SmartCuber
//
//  Presenter + actions for the Sessions management sheet. Mirrors
//  SolvesViewModel's shape: a value type holding the caller's @Query
//  snapshot, with (..., in context:) mutation methods.
//

import Foundation
import SwiftData

struct SessionsViewModel {
  let sessions: [Session]

  var isEmpty: Bool { sessions.isEmpty }

  /// Solve count for a session, shown in its row subtitle.
  func solveCount(for session: Session) -> Int { session.solves.count }

  // ── actions ───────────────────────────────────────────────
  func rename(_ session: Session, to name: String, in context: ModelContext) {
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    session.name = trimmed
    try? context.save()
  }

  /// Creates a new session, optionally making it the active one.
  func createSession(named name: String, makeActive: Bool, in context: ModelContext) {
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let session = Session(name: trimmed.isEmpty ? "New session" : trimmed)
    context.insert(session)
    if makeActive {
      setActive(session, in: context)
    }
    try? context.save()
  }

  /// Marks `session` active and demotes every other session — SwiftData
  /// has no native uniqueness constraint, so "exactly one active" is
  /// enforced procedurally here.
  func setActive(_ session: Session, in context: ModelContext) {
    for other in sessions where other.persistentModelID != session.persistentModelID {
      other.isActive = false
    }
    session.isActive = true
    try? context.save()
  }

  /// Deletes `session` (cascades to its solves) and, if it was active,
  /// promotes a fallback so the app always has an active session.
  func delete(_ session: Session, in context: ModelContext) {
    let wasActive = session.isActive
    context.delete(session)
    if wasActive {
      sessions.first { $0.persistentModelID != session.persistentModelID }?.isActive = true
    }
    try? context.save()
  }
}
