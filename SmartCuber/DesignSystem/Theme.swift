//
//  Theme.swift
//  SmartCuber
//
//  Central palette + typography for the decluttered cube timer.
//  Mirrors the `T` token table from the design source so screens stay
//  visually in sync with "The Smart Cuber.html".
//

import SwiftUI

enum Theme {
  // ── surfaces ──────────────────────────────────────────────
  static let background = Color(hex: "0C0D0F")
  static let surface = Color(hex: "16181C")
  static let surfaceRaised = Color(hex: "1C1F24")

  // ── text ──────────────────────────────────────────────────
  static let text = Color(hex: "F4F5F7")
  static let secondary = Color(hex: "8A8F98")
  static let tertiary = Color(hex: "585D66")

  // ── accents ───────────────────────────────────────────────
  static let mint = Color(hex: "34D9A0")
  static let red = Color(hex: "FF453A")

  // ── hairlines ─────────────────────────────────────────────
  static let hairline = Color.white.opacity(0.06)
  static let hairlineStrong = Color.white.opacity(0.09)

  /// Tabular monospaced face used for every time, scramble, and stat.
  static func mono(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
    Font.system(size: size, weight: weight, design: .monospaced)
      .monospacedDigit()
  }

  /// Geist-flavoured UI face. The system font is the closest always-available
  /// stand-in for Geist on iOS.
  static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
    Font.system(size: size, weight: weight, design: .default)
  }
}
