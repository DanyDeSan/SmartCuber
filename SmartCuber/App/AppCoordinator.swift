//
//  AppCoordinator.swift
//  SmartCuber
//
//  Owns navigation state for the app. Views read the selected tab and the
//  selected solve from here and delegate changes back — they never push or
//  present directly (see ARCHITECTURE.md → Coordinator).
//

import Foundation
import Observation
import SwiftData

@Observable
final class AppCoordinator {
  /// The currently visible tab.
  var selectedTab: AppTab = .timer

  /// The solve highlighted in the Solves detail pane, if any.
  var selectedSolveID: PersistentIdentifier?

  /// Whether the Sessions management sheet is presented.
  var isManagingSessions = false

  func select(solve: Solve) {
    selectedSolveID = solve.persistentModelID
  }

  func presentSessionsManagement() {
    isManagingSessions = true
  }
}
