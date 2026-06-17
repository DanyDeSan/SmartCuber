//
//  SmartCuberApp.swift
//  SmartCuber
//

import SwiftData
import SwiftUI

@main
struct SmartCuberApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Solve.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  var body: some Scene {
    WindowGroup {
      AppCoordinatorView()
    }
    .modelContainer(sharedModelContainer)
  }
}
