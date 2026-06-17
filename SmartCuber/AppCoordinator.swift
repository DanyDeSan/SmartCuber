//
//  AppCoordinator.swift
//  SmartCuber
//

import SwiftUI

@Observable
final class AppCoordinator {
  var path = NavigationPath()

  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  func popToRoot() {
    path = NavigationPath()
  }
}
