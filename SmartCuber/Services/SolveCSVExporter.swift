//
//  SolveCSVExporter.swift
//  SmartCuber
//
//  Builds a CSV export of solves for the Settings tab's "Export solves"
//  share sheet. No SwiftData/UIKit dependency, so the formatting logic is
//  easy to unit test in isolation.
//

import Foundation

enum SolveCSVExporter {
  private static let header = "Date,Time,Penalty,Scramble,Puzzle,Session"

  /// Builds a CSV string for the given solves. Caller controls sort order.
  static func csv(for solves: [Solve]) -> String {
    ([header] + solves.map(row)).joined(separator: "\n")
  }

  private static func row(for solve: Solve) -> String {
    let fields = [
      ISO8601DateFormatter().string(from: solve.date),
      String(format: "%.2f", solve.duration),
      penaltyToken(solve.penalty),
      escape(solve.scramble ?? ""),
      solve.puzzle.label,
      escape(solve.session?.name ?? "")
    ]
    return fields.joined(separator: ",")
  }

  private static func penaltyToken(_ penalty: Penalty) -> String {
    switch penalty {
    case .none: return ""
    case .plusTwo: return "+2"
    case .dnf: return "DNF"
    }
  }

  /// Minimal RFC 4180 escaping: quotes a field (doubling internal quotes)
  /// if it contains a comma, quote, or newline.
  private static func escape(_ field: String) -> String {
    guard field.contains(",") || field.contains("\"") || field.contains("\n") else {
      return field
    }
    return "\"\(field.replacingOccurrences(of: "\"", with: "\"\""))\""
  }
}
