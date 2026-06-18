//
//  SolvesScreenView.swift
//  SmartCuber
//
//  The Solves tab: master list on the left, selected-solve detail on the
//  right with scramble, timestamp and penalty controls.
//

import SwiftData
import SwiftUI

struct SolvesScreenView: View {
  let solves: [Solve]
  let sessionName: String
  let selectedSolveID: PersistentIdentifier?
  let onSelect: (Solve) -> Void
  let onSetPenalty: (Solve, Penalty) -> Void
  let onDelete: (Solve) -> Void
  let onSelectTab: (AppTab) -> Void

  private var selected: Solve? {
    solves.first { $0.persistentModelID == selectedSolveID } ?? solves.first
  }

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        solveList
        detail
      }
      .padding(.leading, 46)
      CubeTabBar(active: .solves, onSelect: onSelectTab)
    }
    .background(Theme.background.ignoresSafeArea())
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
            solveRow(solve: solve, number: solves.count - position)
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
    let isActive = solve.persistentModelID == selected?.persistentModelID
    return Button {
      onSelect(solve)
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
    if let solve = selected, let number = numberFor(solve) {
      SolveDetailPane(
        solve: solve,
        number: number,
        onSetPenalty: { onSetPenalty(solve, $0) },
        onDelete: { onDelete(solve) })
    } else {
      Text("No solves yet")
        .font(Theme.sans(15))
        .foregroundStyle(Theme.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

  private func numberFor(_ solve: Solve) -> Int? {
    guard let index = solves.firstIndex(where: { $0.persistentModelID == solve.persistentModelID })
    else { return nil }
    return solves.count - index
  }
}
