//
//  AppTab.swift
//  SmartCuber
//

import Foundation

/// The four destinations in the bottom tab bar.
enum AppTab: String, CaseIterable, Identifiable {
  case timer
  case stats
  case solves
  case settings

  var id: String { rawValue }

  var title: String {
    switch self {
    case .timer: return "Timer"
    case .stats: return "Stats"
    case .solves: return "Solves"
    case .settings: return "Settings"
    }
  }

  /// SF Symbol approximating the design's custom tab glyphs.
  var systemImage: String {
    switch self {
    case .timer: return "timer"
    case .stats: return "chart.bar"
    case .solves: return "list.bullet"
    case .settings: return "slider.horizontal.3"
    }
  }
}
