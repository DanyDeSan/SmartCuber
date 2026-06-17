//
//  SmartCuberTests.swift
//  SmartCuberTests
//

import Testing
@testable import SmartCuber

struct SmartCuberTests {

    @Test func solveFormattedDurationSubMinute() {
        let solve = Solve(date: .now, duration: 45.67)
        #expect(solve.formattedDuration == "45.67")
    }

    @Test func solveFormattedDurationOverMinute() {
        let solve = Solve(date: .now, duration: 83.45)
        #expect(solve.formattedDuration == "1:23.45")
    }

    @Test func solveFormattedDurationDNF() {
        let solve = Solve(date: .now, duration: 0)
        #expect(solve.formattedDuration == "DNF")
    }

}
