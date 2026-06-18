//
//  TimeFormatter.swift
//  SmartCuber
//
//  Port of the design's `formatTime` helper. Renders a duration in seconds
//  as the centisecond-precision strings the timer and stats screens expect.
//

import Foundation

enum TimeFormatter {
  /// The pieces of a formatted time, mirroring the `{ whole, frac, big }`
  /// shape used by the JSX hero number.
  struct Components: Equatable {
    /// Everything left of the centiseconds, e.g. `"9"` or `"1:23"`.
    let whole: String
    /// Two-digit centiseconds, e.g. `"04"`.
    let fraction: String
    /// The full string, e.g. `"9.04"` or `"1:23.45"`.
    let big: String
  }

  /// Formats a duration given in seconds.
  static func components(seconds: Double) -> Components {
    guard seconds > 0 else {
      return Components(whole: "0", fraction: "00", big: "0.00")
    }

    if seconds < 60 {
      let whole = Int(seconds)
      let centis = centiseconds(of: seconds - Double(whole))
      let fraction = pad(centis)
      return Components(whole: "\(whole)", fraction: fraction, big: "\(whole).\(fraction)")
    }

    let minutes = Int(seconds) / 60
    let remainder = seconds - Double(minutes * 60)
    let wholeSeconds = Int(remainder)
    let centis = centiseconds(of: remainder - Double(wholeSeconds))
    let secondsString = pad(wholeSeconds)
    let fraction = pad(centis)
    let whole = "\(minutes):\(secondsString)"
    return Components(whole: whole, fraction: fraction, big: "\(whole).\(fraction)")
  }

  /// Convenience that returns just the full string (the `.big` field).
  static func string(seconds: Double) -> String {
    components(seconds: seconds).big
  }

  // ── helpers ───────────────────────────────────────────────
  private static func centiseconds(of fractional: Double) -> Int {
    min(99, Int((fractional * 100).rounded()))
  }

  private static func pad(_ value: Int) -> String {
    String(format: "%02d", value)
  }
}
