//
//  AppCoordinatorView.swift
//  SmartCuber
//

import SwiftUI

struct AppCoordinatorView: View {
  @State private var coordinator = AppCoordinator()

  var body: some View {
    NavigationStack(path: Bindable(coordinator).path) {
      TimerView()
    }
    .environment(coordinator)
  }
}
