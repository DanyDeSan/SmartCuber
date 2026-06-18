//
//  SolvesScreenView.swift
//  SmartCuber
//
//  The Solves tab: master list on the left, selected-solve detail on the
//  right with scramble, timestamp and penalty controls. Owns its own query.
//

import SwiftData
import SwiftUI

struct SolvesScreenView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Solve.date, order: .reverse) private var solves: [Solve]
  let sessionName: String
  let coordinator: AppCoordinator

  private var model: SolvesViewModel {
    SolvesViewModel(solves: solves, selectedSolveID: coordinator.selectedSolveID)
  }

  var body: some View {
    Group {
      if model.isEmpty {
        emptyState
      } else {
        HStack(spacing: 0) {
          solveList
          detail
        }
      }
    }
    .background(Theme.background.ignoresSafeArea())
  }

  private var emptyState: some View {
    VStack(spacing: 6) {
      Image(systemName: "list.bullet.rectangle")
        .font(.system(size: 30, weight: .regular))
        .foregroundStyle(Theme.tertiary)
      Text("No solves yet")
        .font(Theme.sans(15, weight: .medium))
        .foregroundStyle(Theme.secondary)
      Text("Solves you finish on the Timer tab will show up here.")
        .font(Theme.sans(12.5))
        .foregroundStyle(Theme.tertiary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  // ── solve list ────────────────────────────────────────────
  private var solveList: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .firstTextBaseline) {
        Text("Solves")
          .font(Theme.sans(21, weight: .bold))
          .foregroundStyle(Theme.text)
        Spacer()
        Text("\(solves.count) · \(sessionName)")
          .font(Theme.mono(13))
          .foregroundStyle(Theme.secondary)
      }
      .padding(.horizontal, 22)
      .padding(.top, 17)
      .padding(.bottom, 12)

      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          ForEach(Array(solves.enumerated()), id: \.element.persistentModelID) { position, solve in
            solveRow(solve: solve, number: model.number(at: position))
          }
        }
      }
    }
    .frame(width: 340)
    .overlay(alignment: .trailing) {
      Rectangle().fill(Theme.hairline).frame(width: 0.5)
    }
  }

  private func solveRow(solve: Solve, number: Int) -> some View {
    let isActive = solve.persistentModelID == model.selected?.persistentModelID
    return Button {
      coordinator.select(solve: solve)
    } label: {
      HStack(spacing: 11) {
        Text(String(format: "%02d", number))
          .font(Theme.mono(12))
          .foregroundStyle(Theme.tertiary)
          .frame(width: 26, alignment: .leading)
        Text(solve.displayTime)
          .font(Theme.mono(16, weight: .medium))
          .foregroundStyle(Theme.text)
          .frame(width: 64, alignment: .leading)
        SolveTagView(penalty: solve.penalty)
        Spacer(minLength: 0)
        Text(RelativeTime.label(for: solve.date))
          .font(Theme.mono(12))
          .foregroundStyle(Theme.tertiary)
      }
      .padding(.horizontal, 22)
      .frame(height: 46)
      .background(isActive ? Color.white.opacity(0.04) : .clear)
      .overlay(alignment: .leading) {
        Rectangle().fill(isActive ? Theme.mint : .clear).frame(width: 2)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }

  // ── detail ────────────────────────────────────────────────
  @ViewBuilder private var detail: some View {
    if let solve = model.selected, let number = model.number(for: solve) {
      SolveDetailPane(
        solve: solve,
        number: number,
        onSetPenalty: { model.setPenalty(solve, to: $0, in: modelContext) },
        onDelete: { model.delete(solve, coordinator: coordinator, in: modelContext) })
    }
  }
}
