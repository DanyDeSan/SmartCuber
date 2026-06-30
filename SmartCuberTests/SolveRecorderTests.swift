//
//  SolveRecorderTests.swift
//  SmartCuberTests
//

import Foundation
@testable import SmartCuber
import SwiftData
import Testing

@MainActor
struct SolveRecorderTests {
  private func makeContext() throws -> ModelContext {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Solve.self, Session.self, configurations: config)
    return ModelContext(container)
  }

  @Test func firstSolveIsAlwaysPersonalBest() throws {
    let context = try makeContext()
    let isPB = SolveRecorder.record(
      duration: 12, scramble: "R U", puzzle: .threeByThree, in: context)
    #expect(isPB)
  }

  @Test func fasterSolveBeatsPreviousBest() throws {
    let context = try makeContext()
    SolveRecorder.record(duration: 12, scramble: "", puzzle: .threeByThree, in: context)
    let isPB = SolveRecorder.record(duration: 9, scramble: "", puzzle: .threeByThree, in: context)
    #expect(isPB)
  }

  @Test func slowerSolveIsNotPersonalBest() throws {
    let context = try makeContext()
    SolveRecorder.record(duration: 9, scramble: "", puzzle: .threeByThree, in: context)
    let isPB = SolveRecorder.record(duration: 11, scramble: "", puzzle: .threeByThree, in: context)
    #expect(!isPB)
  }

  @Test func anotherPuzzlesBestDoesNotInterfere() throws {
    let context = try makeContext()
    // A fast 2×2 must not make a slower first 3×3 solve look non-PB.
    SolveRecorder.record(duration: 5, scramble: "", puzzle: .twoByTwo, in: context)
    let isPB = SolveRecorder.record(
      duration: 12, scramble: "", puzzle: .threeByThree, in: context)
    #expect(isPB)
  }

  @Test func dnfNeverCountsAsPersonalBest() throws {
    let context = try makeContext()
    let isPB = SolveRecorder.record(
      duration: 5, scramble: "", puzzle: .threeByThree, penalty: .dnf, in: context)
    #expect(!isPB)
  }

  @Test func recordsIntoActiveSessionEvenWhenNotMostRecent() throws {
    let context = try makeContext()
    let older = Session(name: "Older", createdAt: .now.addingTimeInterval(-3600), isActive: true)
    let newer = Session(name: "Newer", createdAt: .now)
    context.insert(older)
    context.insert(newer)

    SolveRecorder.record(duration: 10, scramble: "", puzzle: .threeByThree, in: context)

    let solves = try context.fetch(FetchDescriptor<Solve>())
    #expect(solves.first?.session?.name == "Older")
  }

  @Test func promotesMostRecentSessionWhenNoneIsActiveYet() throws {
    let context = try makeContext()
    let older = Session(name: "Older", createdAt: .now.addingTimeInterval(-3600))
    let newer = Session(name: "Newer", createdAt: .now)
    context.insert(older)
    context.insert(newer)

    SolveRecorder.record(duration: 10, scramble: "", puzzle: .threeByThree, in: context)

    let solves = try context.fetch(FetchDescriptor<Solve>())
    #expect(solves.first?.session?.name == "Newer")
    #expect(newer.isActive)
  }
}
