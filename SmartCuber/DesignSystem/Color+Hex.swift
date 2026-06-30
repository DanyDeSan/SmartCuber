//
//  Color+Hex.swift
//  SmartCuber
//

import SwiftUI
import UIKit

extension Color {
  /// Creates a color from a hex string such as `"#0C0D0F"` or `"34D9A0"`.
  /// An optional `opacity` overrides any alpha and lets callers mirror the
  /// `rgba(...)` hairlines used throughout the design.
  init(hex: String, opacity: Double = 1) {
    let cleaned = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
    var value: UInt64 = 0
    Scanner(string: cleaned).scanHexInt64(&value)

    let red = Double((value & 0xFF0000) >> 16) / 255
    let green = Double((value & 0x00FF00) >> 8) / 255
    let blue = Double(value & 0x0000FF) / 255

    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }

  /// A color that resolves to a different hex value (and, optionally,
  /// opacity) in light vs. dark appearance, reacting live to the
  /// system/window trait collection — and to a `.preferredColorScheme`
  /// override applied above it in the view hierarchy — the same mechanism
  /// `Color.primary` uses under the hood. Light-mode UI conventionally
  /// needs slightly higher alpha than dark mode for the same visual
  /// weight, hence the separate `lightOpacity`/`darkOpacity`.
  static func adaptive(
    lightHex: String,
    darkHex: String,
    lightOpacity: Double = 1,
    darkOpacity: Double = 1
  ) -> Color {
    Color(UIColor { traits in
      let isDark = traits.userInterfaceStyle == .dark
      let hex = isDark ? darkHex : lightHex
      let opacity = isDark ? darkOpacity : lightOpacity
      return UIColor(Color(hex: hex, opacity: opacity))
    })
  }
}
