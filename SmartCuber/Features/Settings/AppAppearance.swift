//
//  AppAppearance.swift
//  SmartCuber
//
//  The Settings tab's Appearance override. "System" (the default) means no
//  override at all — RootView passes a nil `ColorScheme`, so the app simply
//  follows the device's light/dark setting via Theme's adaptive colors.
//

import SwiftUI

enum AppAppearance: String, Codable, CaseIterable, Identifiable {
  case system
  case light
  case dark

  var id: String { rawValue }

  var label: String {
    switch self {
    case .system: return "System"
    case .light: return "Light"
    case .dark: return "Dark"
    }
  }

  /// `nil` means "don't override" — passed straight to `.preferredColorScheme`.
  var colorScheme: ColorScheme? {
    switch self {
    case .system: return nil
    case .light: return .light
    case .dark: return .dark
    }
  }
}
