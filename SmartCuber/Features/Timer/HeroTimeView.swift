//
//  HeroTimeView.swift
//  SmartCuber
//
//  The large, tabular monospaced time at the centre of the timer screen.
//

import SwiftUI

struct HeroTimeView: View {
  let seconds: Double
  let color: Color
  var size: CGFloat = 90

  var body: some View {
    Text(TimeFormatter.string(seconds: seconds))
      .font(Theme.mono(size, weight: .medium))
      .tracking(-size * 0.02)
      .foregroundStyle(color)
      .contentTransition(.numericText())
      .animation(.snappy(duration: 0.2), value: color)
  }
}
