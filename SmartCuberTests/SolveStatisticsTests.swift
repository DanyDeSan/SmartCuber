//
//  SolveStatisticsTests.swift
//  SmartCuberTests
//

import Foundation
@testable import SmartCuber
import Testing

struct SolveStatisticsTests {
  private func solves(_ durations: [Double], penalties: [Penalty] = []) -> [Solve] {
    durations.enumerated().map { index, duration in
      Solve(
        date: .now,
        duration: duration,
        penalty: index < penalties.count ? penalties[index] : .none)
    }
  }

  @Test func bestIsLowestEffectiveTime() {
    let stats = SolveStatistics(solves: solves([12, 9.61, 11]))
    #expect(stats.best == "9.61")
  }

  @Test func averageOfFiveDropsBestAndWorst() {
    // Trimmed mean of [10,11,12,13,14] → mean(11,12,13) = 12.
    let stats = SolveStatistics(solves: solves([14, 13, 12, 11, 10]))
    #expect(stats.ao5 == "12.00")
  }

  @Test func averageIsPlaceholderWithoutEnoughSolves() {
    let stats = SolveStatistics(solves: solves([10, 11, 12, 13]))
    #expect(stats.ao5 == SolveStatistics.placeholder)
    #expect(stats.ao12 == SolveStatistics.placeholder)
  }

  @Test func countIncludesEverySolve() {
    let stats = SolveStatistics(solves: solves([10, 11, 12]))
    #expect(stats.count == "3")
  }

  @Test func singleDNFIsDroppedAsWorstInAverage() {
    // [10,11,12,13] + one DNF → DNF trims as worst → mean(11,12,13) = 12.
    let stats = SolveStatistics(
      solves: solves([10, 11, 12, 13, 0], penalties: [.none, .none, .none, .none, .dnf]))
    #expect(stats.ao5 == "12.00")
  }

  @Test func twoDNFsMakeTheAverageDNF() {
    let stats = SolveStatistics(
      solves: solves([10, 11, 12, 0, 0], penalties: [.none, .none, .none, .dnf, .dnf]))
    #expect(stats.ao5 == "DNF")
  }

  @Test func allDNFLeavesBestAsPlaceholder() {
    let stats = SolveStatistics(solves: solves([0, 0], penalties: [.dnf, .dnf]))
    #expect(stats.best == SolveStatistics.placeholder)
  }
}
