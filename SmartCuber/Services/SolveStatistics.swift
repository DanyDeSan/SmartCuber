//
//  SolveStatistics.swift
//  SmartCuber
//
//  Computes the session figures shown on the Stats tab: best, averages
//  (ao5 / ao12 / ao50), session mean and count. Ports the design's
//  `computeStats` / `aoN` helpers with WCA DNF handling.
//

import Foundation

struct SolveStatistics {
  let best: String
  let ao5: String
  let ao12: String
  let ao50: String
  let mean: String
  let count: String

  /// Placeholder shown when a figure can't be computed yet.
  static let placeholder = "—"

  /// Builds the statistics for a list of solves ordered newest-first.
  init(solves: [Solve]) {
    let finished = solves.filter { !$0.isDNF }
    let count = solves.count

    self.count = "\(count)"
    self.best = finished.map(\.effectiveDuration).min().map(Self.format) ?? Self.placeholder
    self.mean = Self.meanString(of: finished.map(\.effectiveDuration))
    self.ao5 = Self.averageString(of: solves, window: 5)
    self.ao12 = Self.averageString(of: solves, window: 12)
    self.ao50 = Self.averageString(of: solves, window: 50)
  }

  // ── average of N (drop best + worst) ──────────────────────
  /// The trimmed mean of the most recent `window` solves, as a string.
  /// Returns the placeholder when there aren't enough solves and "DNF"
  /// when two or more solves in the window are did-not-finish.
  static func averageString(of solves: [Solve], window: Int) -> String {
    guard solves.count >= window else { return placeholder }
    let recent = Array(solves.prefix(window))
    let dnfCount = recent.filter(\.isDNF).count
    guard dnfCount < 2 else { return "DNF" }

    // Sort by effective time — a single DNF sorts to the end (infinity) and
    // is removed as the dropped worst.
    let sorted = recent.map(\.effectiveDuration).sorted()
    let trimmed = sorted.dropFirst().dropLast()
    return meanString(of: Array(trimmed))
  }

  // ── helpers ───────────────────────────────────────────────
  private static func meanString(of values: [Double]) -> String {
    guard !values.isEmpty else { return placeholder }
    let total = values.reduce(0, +)
    return format(total / Double(values.count))
  }

  private static func format(_ seconds: Double) -> String {
    guard seconds.isFinite else { return "DNF" }
    return TimeFormatter.string(seconds: seconds)
  }
}
