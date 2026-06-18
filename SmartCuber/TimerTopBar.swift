//
//  TimerTopBar.swift
//  SmartCuber
//
//  The timer's top bar: puzzle picker chip + session label on the left, the
//  scramble centred, and the overflow (•••) button on the right.
//

import SwiftUI

struct TimerTopBar: View {
  let scramble: String
  let puzzleLabel: String
  let sessionName: String
  var puzzleActive = false
  var menuActive = false
  let onPuzzleTap: () -> Void
  let onMenuTap: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      leading
      Text(scramble)
        .font(Theme.mono(15, weight: .regular))
        .tracking(0.9)
        .foregroundStyle(Theme.secondary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
      overflowButton
    }
    .padding(.horizontal, 22)
    .padding(.top, 15)
  }

  private var leading: some View {
    HStack(spacing: 9) {
      Button(action: onPuzzleTap) {
        HStack(spacing: 5) {
          Text(puzzleLabel)
            .font(Theme.sans(14.5, weight: .semibold))
            .foregroundStyle(Theme.text)
          Image(systemName: "chevron.down")
            .font(.system(size: 9, weight: .semibold))
            .foregroundStyle(Theme.secondary)
            .rotationEffect(.degrees(puzzleActive ? 180 : 0))
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 4)
        .background(
          puzzleActive ? Color.white.opacity(0.07) : .clear,
          in: RoundedRectangle(cornerRadius: 8))
      }
      .buttonStyle(.plain)

      Rectangle().fill(Theme.hairlineStrong).frame(width: 0.5, height: 13)
      Text(sessionName)
        .font(Theme.sans(13.5, weight: .regular))
        .foregroundStyle(Theme.secondary)
    }
    .fixedSize()
  }

  private var overflowButton: some View {
    Button(action: onMenuTap) {
      HStack(spacing: 3.5) {
        ForEach(0..<3) { _ in
          Circle()
            .fill(menuActive ? Theme.text : Theme.secondary)
            .frame(width: 3.5, height: 3.5)
        }
      }
      .padding(.horizontal, 4)
      .padding(.vertical, 6)
      .background(
        menuActive ? Color.white.opacity(0.07) : .clear,
        in: RoundedRectangle(cornerRadius: 8))
    }
    .buttonStyle(.plain)
  }
}
