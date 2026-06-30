//
//  Session.swift
//  SmartCuber
//
//  A named grouping of solves done in one sitting (e.g. "Casual").
//

import Foundation
import SwiftData

@Model
final class Session {
  var name: String
  var createdAt: Date
  /// The session new solves record into. Exactly one session should be
  /// active at a time — enforced by `SessionsViewModel`/`SolveRecorder`,
  /// not by a SwiftData constraint (SwiftData has no native uniqueness).
  var isActive: Bool

  @Relationship(deleteRule: .cascade, inverse: \Solve.session)
  var solves: [Solve] = []

  init(name: String, createdAt: Date = .now, isActive: Bool = false) {
    self.name = name
    self.createdAt = createdAt
    self.isActive = isActive
  }
}
