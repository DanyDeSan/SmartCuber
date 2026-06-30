//
//  SessionsViewModelTests.swift
//  SmartCuberTests
//

import Foundation
@testable import SmartCuber
import SwiftData
import Testing

@MainActor
struct SessionsViewModelTests {
  private func makeContext() throws -> ModelContext {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Solve.self, Session.self, configurations: config)
    return ModelContext(container)
  }

  @Test func setActiveDemotesEveryOtherSession() throws {
    let context = try makeContext()
    let sessionA = Session(name: "A", isActive: true)
    let sessionB = Session(name: "B")
    context.insert(sessionA)
    context.insert(sessionB)
    let model = SessionsViewModel(sessions: [sessionA, sessionB])

    model.setActive(sessionB, in: context)

    #expect(!sessionA.isActive)
    #expect(sessionB.isActive)
  }

  @Test func deletingActiveSessionPromotesAFallback() throws {
    let context = try makeContext()
    let sessionA = Session(name: "A", isActive: true)
    let sessionB = Session(name: "B")
    context.insert(sessionA)
    context.insert(sessionB)
    let model = SessionsViewModel(sessions: [sessionA, sessionB])

    model.delete(sessionA, in: context)

    #expect(sessionB.isActive)
  }

  @Test func deletingNonActiveSessionLeavesActiveUntouched() throws {
    let context = try makeContext()
    let sessionA = Session(name: "A", isActive: true)
    let sessionB = Session(name: "B")
    context.insert(sessionA)
    context.insert(sessionB)
    let model = SessionsViewModel(sessions: [sessionA, sessionB])

    model.delete(sessionB, in: context)

    #expect(sessionA.isActive)
  }

  @Test func renameTrimsWhitespace() throws {
    let context = try makeContext()
    let session = Session(name: "Original")
    context.insert(session)
    let model = SessionsViewModel(sessions: [session])

    model.rename(session, to: "  Renamed  ", in: context)

    #expect(session.name == "Renamed")
  }

  @Test func renameRejectsBlankName() throws {
    let context = try makeContext()
    let session = Session(name: "Original")
    context.insert(session)
    let model = SessionsViewModel(sessions: [session])

    model.rename(session, to: "   ", in: context)

    #expect(session.name == "Original")
  }

  @Test func createSessionCanBeMadeActiveImmediately() throws {
    let context = try makeContext()
    let existing = Session(name: "Existing", isActive: true)
    context.insert(existing)
    let model = SessionsViewModel(sessions: [existing])

    model.createSession(named: "Fresh", makeActive: true, in: context)

    let sessions = try context.fetch(FetchDescriptor<Session>())
    #expect(sessions.first { $0.name == "Fresh" }?.isActive == true)
    #expect(!existing.isActive)
  }
}
