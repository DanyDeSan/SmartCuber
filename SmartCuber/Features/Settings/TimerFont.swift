//
//  TimerFont.swift
//  SmartCuber
//
//  The typeface family used for every time/scramble/stat readout in the app
//  (see Theme.monoDesign). All three stay on a monospaced-digit system
//  design so the hero time never loses tabular alignment.
//

import SwiftUI

enum TimerFont: String, Codable, CaseIterable, Identifiable {
  case systemMono
  case rounded
  case classic

  var id: String { rawValue }

  /// The label rendered in the Settings picker.
  var label: String {
    switch self {
    case .systemMono: return "Mono"
    case .rounded: return "Rounded"
    case .classic: return "Classic"
    }
  }

  /// The `Font.Design` applied by `Theme.mono`.
  var design: Font.Design {
    switch self {
    case .systemMono: return .monospaced
    case .rounded: return .rounded
    case .classic: return .serif
    }
  }
}
