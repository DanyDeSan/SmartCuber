//
//  SolvePenaltyTests.swift
//  SmartCuberTests
//

import Foundation
@testable import SmartCuber
import Testing

struct SolvePenaltyTests {

  @Test func plusTwoAddsTwoSecondsToEffectiveTime() {
    let solve = Solve(date: .now, duration: 13.11, penalty: .plusTwo)
    #expect(abs(solve.effectiveDuration - 15.11) < 0.0001)
  }

  @Test func plusTwoDisplayShowsTrailingPlus() {
    let solve = Solve(date: .now, duration: 13.11, penalty: .plusTwo)
    #expect(solve.displayTime == "15.11+")
  }

  @Test func dnfIsInfiniteAndDisplaysDNF() {
    let solve = Solve(date: .now, duration: 9.5, penalty: .dnf)
    #expect(solve.isDNF)
    #expect(solve.effectiveDuration == .infinity)
    #expect(solve.displayTime == "DNF")
  }

  @Test func noPenaltyDisplaysPlainTime() {
    let solve = Solve(date: .now, duration: 9.61)
    #expect(solve.displayTime == "9.61")
    #expect(solve.effectiveDuration == 9.61)
  }
}
