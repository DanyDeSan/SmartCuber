//
//  StatsScreenView.swift
//  SmartCuber
//
//  The Stats tab: average cards up top, full solve history below in two
//  columns. The session best is rendered in mint. Owns its own solve query.
//

import SwiftData
import SwiftUI

struct StatsScreenView: View {
  @Query(sort: \Solve.date, order: .reverse) private var solves: [Solve]
  let sessionName: String
  let puzzleLabel: String

  private var model: StatsViewModel { StatsViewModel(solves: solves) }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      header
      cards
      if model.isEmpty {
        emptyState
      } else {
        history
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(Theme.background.ignoresSafeArea())
  }

  private var header: some View {
    HStack(alignment: .firstTextBaseline) {
      Text("Statistics")
        .font(Theme.sans(21, weight: .bold))
        .foregroundStyle(Theme.text)
      Text("\(sessionName) · \(puzzleLabel)")
        .font(Theme.sans(13, weight: .regular))
        .foregroundStyle(Theme.secondary)
      Spacer()
      Label("This session", systemImage: "arrow.clockwise")
        .font(Theme.sans(12.5, weight: .medium))
        .foregroundStyle(Theme.secondary)
    }
    .padding(.horizontal, 24)
    .padding(.top, 17)
  }

  private var cards: some View {
    let stats = model.statistics
    return HStack(spacing: 9) {
      StatCardView(label: "best", value: stats.best, accent: true)
      StatCardView(label: "ao5", value: stats.ao5)
      StatCardView(label: "ao12", value: stats.ao12)
      StatCardView(label: "ao50", value: stats.ao50)
      StatCardView(label: "mean", value: stats.mean)
      StatCardView(label: "solves", value: stats.count)
    }
    .padding(.horizontal, 24)
    .padding(.top, 15)
  }

  private var emptyState: some View {
    VStack(spacing: 6) {
      Image(systemName: "chart.bar.xaxis")
        .font(.system(size: 30, weight: .regular))
        .foregroundStyle(Theme.tertiary)
      Text("No solves yet")
        .font(Theme.sans(15, weight: .medium))
        .foregroundStyle(Theme.secondary)
      Text("Finish a solve on the Timer tab to start building stats.")
        .font(Theme.sans(12.5))
        .foregroundStyle(Theme.tertiary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var history: some View {
    let columns = model.historyColumns
    return VStack(alignment: .leading, spacing: 2) {
      Text("SOLVE HISTORY")
        .font(Theme.sans(10, weight: .semibold))
        .tracking(1)
        .foregroundStyle(Theme.tertiary)
        .padding(.leading, 4)
      HStack(alignment: .top, spacing: 18) {
        column(range: columns.left)
        column(range: columns.right)
          .overlay(alignment: .leading) {
            Rectangle().fill(Theme.hairline).frame(width: 0.5).offset(x: -9)
          }
      }
    }
    .padding(.horizontal, 24)
    .padding(.top, 14)
  }

  private func column(range: Range<Int>) -> some View {
    VStack(spacing: 0) {
      ForEach(range, id: \.self) { position in
        historyRow(solve: solves[position], number: model.number(at: position))
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func historyRow(solve: Solve, number: Int) -> some View {
    HStack(spacing: 10) {
      Text(String(format: "%02d", number))
        .font(Theme.mono(11.5))
        .foregroundStyle(Theme.tertiary)
        .frame(width: 28, alignment: .leading)
      Text(solve.displayTime)
        .font(Theme.mono(15))
        .foregroundStyle(Theme.text)
        .frame(width: 60, alignment: .leading)
      SolveTagView(
        penalty: solve.penalty,
        isPersonalBest: solve.persistentModelID == model.bestSolveID)
      Spacer(minLength: 0)
      Text(RelativeTime.label(for: solve.date))
        .font(Theme.mono(11.5))
        .foregroundStyle(Theme.tertiary)
    }
    .frame(height: 33)
  }
}
