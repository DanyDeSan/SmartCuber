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

  @Relationship(deleteRule: .cascade, inverse: \Solve.session)
  var solves: [Solve] = []

  init(name: String, createdAt: Date = .now) {
    self.name = name
    self.createdAt = createdAt
  }
}
