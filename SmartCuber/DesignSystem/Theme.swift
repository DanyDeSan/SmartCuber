//
//  Theme.swift
//  SmartCuber
//
//  Central palette + typography for the decluttered cube timer.
//  Mirrors the `T` token table from the design source so screens stay
//  visually in sync with "The Smart Cuber.html". Every color token reacts
//  live to the system/window appearance (light vs. dark) via `Color
//  .adaptive`, and to the Settings tab's Appearance override via
//  `.preferredColorScheme` applied higher in the hierarchy (see RootView).
//

import SwiftUI

enum Theme {
  // ── surfaces ──────────────────────────────────────────────
  static let background = Color.adaptive(lightHex: "F7F7F8", darkHex: "0C0D0F")
  static let surface = Color.adaptive(lightHex: "FFFFFF", darkHex: "16181C")
  static let surfaceRaised = Color.adaptive(lightHex: "EDEEF0", darkHex: "1C1F24")

  // ── text ──────────────────────────────────────────────────
  static let text = Color.adaptive(lightHex: "15171A", darkHex: "F4F5F7")
  static let secondary = Color.adaptive(lightHex: "6B7078", darkHex: "8A8F98")
  static let tertiary = Color.adaptive(lightHex: "9499A1", darkHex: "585D66")

  // ── accents ───────────────────────────────────────────────
  static let mint = Color.adaptive(lightHex: "1FAE80", darkHex: "34D9A0")
  static let red = Color.adaptive(lightHex: "D6362C", darkHex: "FF453A")
  /// WCA inspection countdown — distinct from `ready` (mint) and `holding`
  /// (red) so the timer's color-coded state stays unambiguous at a glance.
  static let amber = Color.adaptive(lightHex: "D98F1F", darkHex: "FFB23F")

  // ── hairlines ─────────────────────────────────────────────
  static let hairline = Color.adaptive(
    lightHex: "000000", darkHex: "FFFFFF", lightOpacity: 0.08, darkOpacity: 0.06)
  static let hairlineStrong = Color.adaptive(
    lightHex: "000000", darkHex: "FFFFFF", lightOpacity: 0.12, darkOpacity: 0.09)

  // ── subtle fills ──────────────────────────────────────────
  // Generic low-opacity fills for icon tiles, active-row highlights, and
  // button backgrounds — a separate role from the hairline border tokens.
  /// Unweighted adaptive base (white in dark, black in light) for call
  /// sites that apply their own variable opacity on top.
  static let subtleFillBase = Color.adaptive(lightHex: "000000", darkHex: "FFFFFF")
  static let subtleFill = Color.adaptive(
    lightHex: "000000", darkHex: "FFFFFF", lightOpacity: 0.05, darkOpacity: 0.04)
  static let subtleFillStrong = Color.adaptive(
    lightHex: "000000", darkHex: "FFFFFF", lightOpacity: 0.07, darkOpacity: 0.05)

  /// The font design behind `mono(_:weight:)`, driven by the Settings tab's
  /// "Timer font" picker (`TimerSettings.timerFont`). A single mutable token
  /// here avoids threading a font parameter through every one of the ~7
  /// call sites that render a time, scramble, or stat figure.
  static var monoDesign: Font.Design = .monospaced

  /// Tabular monospaced face used for every time, scramble, and stat.
  static func mono(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
    Font.system(size: size, weight: weight, design: monoDesign)
      .monospacedDigit()
  }

  /// Geist-flavoured UI face. The system font is the closest always-available
  /// stand-in for Geist on iOS.
  static func sans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
    Font.system(size: size, weight: weight, design: .default)
  }
}
