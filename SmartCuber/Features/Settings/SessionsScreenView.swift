//
//  SessionsScreenView.swift
//  SmartCuber
//
//  Sessions management sheet, presented from the Settings tab's "Manage
//  sessions" row. Create, rename, delete, and pick which session new
//  solves record into.
//

import SwiftData
import SwiftUI

struct SessionsScreenView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @Query(sort: \Session.createdAt, order: .reverse) private var sessions: [Session]

  @State private var renamingSessionID: PersistentIdentifier?
  @State private var draftName = ""
  @State private var isAddingSession = false
  @State private var newSessionName = ""

  private var model: SessionsViewModel { SessionsViewModel(sessions: sessions) }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      header
      SettingsGroup(title: "Sessions") {
        ForEach(Array(sessions.enumerated()), id: \.element.persistentModelID) { index, session in
          sessionRow(session, isLast: index == sessions.count - 1)
        }
      }
      .padding(.horizontal, 28)
      .padding(.top, 12)
      Spacer(minLength: 0)
    }
    .background(Theme.background.ignoresSafeArea())
    .alert("New Session", isPresented: $isAddingSession) {
      TextField("Name", text: $newSessionName)
      Button("Create") {
        model.createSession(named: newSessionName, makeActive: true, in: modelContext)
        newSessionName = ""
      }
      Button("Cancel", role: .cancel) { newSessionName = "" }
    }
  }

  private var header: some View {
    HStack(alignment: .firstTextBaseline) {
      Text("Manage Sessions")
        .font(Theme.sans(21, weight: .bold))
        .foregroundStyle(Theme.text)
      Spacer()
      Button {
        isAddingSession = true
      } label: {
        Label("New", systemImage: "plus")
          .font(Theme.sans(13.5, weight: .medium))
      }
      Button("Done") { dismiss() }
        .font(Theme.sans(13.5, weight: .semibold))
        .padding(.leading, 14)
    }
    .padding(.horizontal, 28)
    .padding(.top, 17)
  }

  private func sessionRow(_ session: Session, isLast: Bool) -> some View {
    VStack(spacing: 0) {
      HStack(spacing: 13) {
        activeIndicator(for: session)
        if renamingSessionID == session.persistentModelID {
          TextField("Name", text: $draftName, onCommit: { commitRename(session) })
            .textFieldStyle(.plain)
            .font(Theme.sans(14.5, weight: .regular))
            .foregroundStyle(Theme.text)
        } else {
          VStack(alignment: .leading, spacing: 1) {
            Text(session.name)
              .font(Theme.sans(14.5, weight: .regular))
              .foregroundStyle(Theme.text)
            let count = model.solveCount(for: session)
            Text("\(count) solve\(count == 1 ? "" : "s")")
              .font(Theme.sans(11.5, weight: .regular))
              .foregroundStyle(Theme.tertiary)
          }
          .contentShape(Rectangle())
          .onTapGesture { model.setActive(session, in: modelContext) }
        }
        Spacer(minLength: 0)
        rowActions(for: session)
      }
      .padding(.horizontal, 16)
      .frame(minHeight: 50)
      if !isLast {
        Rectangle().fill(Theme.hairline).frame(height: 0.5)
      }
    }
  }

  private func activeIndicator(for session: Session) -> some View {
    Image(systemName: session.isActive ? "checkmark.circle.fill" : "circle")
      .font(.system(size: 16, weight: .medium))
      .foregroundStyle(session.isActive ? Theme.mint : Theme.tertiary)
  }

  private func rowActions(for session: Session) -> some View {
    HStack(spacing: 8) {
      Button {
        beginRename(session)
      } label: {
        Image(systemName: "pencil")
          .font(.system(size: 13, weight: .medium))
          .foregroundStyle(Theme.secondary)
          .frame(width: 32, height: 32)
          .background(Theme.subtleFill, in: RoundedRectangle(cornerRadius: 9))
      }
      .buttonStyle(.plain)

      Button {
        model.delete(session, in: modelContext)
      } label: {
        Image(systemName: "trash")
          .font(.system(size: 13, weight: .medium))
          .foregroundStyle(Theme.red)
          .frame(width: 32, height: 32)
          .background(Theme.subtleFill, in: RoundedRectangle(cornerRadius: 9))
      }
      .buttonStyle(.plain)
      .disabled(sessions.count == 1)
    }
  }

  private func beginRename(_ session: Session) {
    draftName = session.name
    renamingSessionID = session.persistentModelID
  }

  private func commitRename(_ session: Session) {
    model.rename(session, to: draftName, in: modelContext)
    renamingSessionID = nil
  }
}
