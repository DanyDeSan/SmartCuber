//
//  Color+Hex.swift
//  SmartCuber
//

import SwiftUI

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
}
