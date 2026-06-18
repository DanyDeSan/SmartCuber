//
//  SolveDetailPane.swift
//  SmartCuber
//
//  The right-hand detail for the selected solve: big time, timestamp,
//  scramble and the OK / +2 / DNF / delete penalty controls.
//

import SwiftUI

struct SolveDetailPane: View {
  let solve: Solve
  let number: Int
  let onSetPenalty: (Penalty) -> Void
  let onDelete: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      header
      time
      scramble
      Spacer(minLength: 0)
      penaltyControls
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 28)
    .padding(.top, 19)
    .padding(.bottom, 18)
  }

  private var header: some View {
    HStack {
      Text("SOLVE \(String(format: "%02d", number))")
        .font(Theme.sans(11, weight: .semibold))
        .tracking(1.2)
        .foregroundStyle(Theme.tertiary)
      Spacer()
      Text(timestamp)
        .font(Theme.sans(12.5, weight: .regular))
        .foregroundStyle(Theme.secondary)
    }
  }

  private var time: some View {
    HStack(alignment: .firstTextBaseline, spacing: 12) {
      Text(solve.displayTime)
        .font(Theme.mono(56, weight: .medium))
        .foregroundStyle(solve.isDNF ? Theme.red : Theme.text)
      if solve.penalty == .plusTwo {
        Text("incl. +2")
          .font(Theme.sans(12.5, weight: .semibold))
          .foregroundStyle(Theme.secondary)
      }
    }
    .padding(.top, 14)
  }

  private var scramble: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text("SCRAMBLE")
        .font(Theme.sans(10, weight: .semibold))
        .tracking(1)
        .foregroundStyle(Theme.tertiary)
      Text(solve.scramble ?? "—")
        .font(Theme.mono(14))
        .tracking(0.6)
        .foregroundStyle(Theme.secondary)
        .lineSpacing(4)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(.top, 20)
  }

  private var penaltyControls: some View {
    VStack(alignment: .leading, spacing: 9) {
      Text("PENALTY")
        .font(Theme.sans(10, weight: .semibold))
        .tracking(1)
        .foregroundStyle(Theme.tertiary)
      HStack(spacing: 9) {
        penaltyButton(.none)
        penaltyButton(.plusTwo)
        penaltyButton(.dnf)
        Rectangle().fill(Theme.hairline).frame(width: 0.5).padding(.vertical, 2)
        deleteButton
      }
    }
  }

  private func penaltyButton(_ penalty: Penalty) -> some View {
    let isActive = solve.penalty == penalty
    let danger = penalty == .dnf
    let activeColor = danger ? Theme.red : Theme.mint
    return Button {
      onSetPenalty(penalty)
    } label: {
      Text(penalty.controlLabel)
        .font(Theme.sans(13.5, weight: isActive ? .semibold : .medium))
        .foregroundStyle(isActive ? activeColor : Theme.secondary)
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(
          isActive ? activeColor.opacity(0.12) : Color.white.opacity(0.04),
          in: RoundedRectangle(cornerRadius: 11))
        .overlay(
          RoundedRectangle(cornerRadius: 11)
            .strokeBorder(isActive ? activeColor.opacity(0.35) : .clear, lineWidth: 1))
    }
    .buttonStyle(.plain)
  }

  private var deleteButton: some View {
    Button(action: onDelete) {
      Image(systemName: "trash")
        .font(.system(size: 15, weight: .medium))
        .foregroundStyle(Theme.red)
        .frame(width: 44, height: 40)
        .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 11))
    }
    .buttonStyle(.plain)
  }

  private var timestamp: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    let time = formatter.string(from: solve.date)
    let day = Calendar.current.isDateInToday(solve.date)
      ? "Today"
      : solve.date.formatted(.dateTime.month().day())
    return "\(day) · \(time)"
  }
}
