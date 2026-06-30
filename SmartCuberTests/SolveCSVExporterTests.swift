//
//  SolveCSVExporterTests.swift
//  SmartCuberTests
//

import Foundation
@testable import SmartCuber
import Testing

struct SolveCSVExporterTests {
  @Test func emptyInputProducesHeaderOnly() {
    let csv = SolveCSVExporter.csv(for: [])
    #expect(csv == "Date,Time,Penalty,Scramble,Puzzle,Session")
  }

  @Test func headerRowIsExact() {
    let csv = SolveCSVExporter.csv(for: [Solve(date: .now, duration: 12.34)])
    let header = csv.components(separatedBy: "\n").first
    #expect(header == "Date,Time,Penalty,Scramble,Puzzle,Session")
  }

  /// The third comma-delimited field (Date,Time,Penalty,...) — safe to
  /// split naively on "," here since none of these test scrambles contain
  /// one (comma-escaping is verified separately).
  private func penaltyField(_ row: String) -> String {
    row.components(separatedBy: ",")[2]
  }

  @Test func noPenaltyFieldIsEmpty() {
    let solve = Solve(date: .now, duration: 12.34, scramble: "R U", penalty: .none)
    let row = SolveCSVExporter.csv(for: [solve]).components(separatedBy: "\n")[1]
    #expect(penaltyField(row).isEmpty)
  }

  @Test func plusTwoPenaltyTokenIsPlusTwo() {
    let solve = Solve(date: .now, duration: 12.34, scramble: "R U", penalty: .plusTwo)
    let row = SolveCSVExporter.csv(for: [solve]).components(separatedBy: "\n")[1]
    #expect(penaltyField(row) == "+2")
  }

  @Test func dnfPenaltyTokenIsDNF() {
    let solve = Solve(date: .now, duration: 12.34, scramble: "R U", penalty: .dnf)
    let row = SolveCSVExporter.csv(for: [solve]).components(separatedBy: "\n")[1]
    #expect(penaltyField(row) == "DNF")
  }

  @Test func scrambleContainingCommaIsQuoted() {
    let solve = Solve(date: .now, duration: 1, scramble: "R, U")
    let row = SolveCSVExporter.csv(for: [solve]).components(separatedBy: "\n")[1]
    #expect(row.contains("\"R, U\""))
  }

  @Test func multipleSolvesProduceHeaderPlusOneRowEach() {
    let solves = [
      Solve(date: .now, duration: 10),
      Solve(date: .now, duration: 11),
      Solve(date: .now, duration: 12)
    ]
    let lines = SolveCSVExporter.csv(for: solves).components(separatedBy: "\n")
    #expect(lines.count == 4)
  }
}
