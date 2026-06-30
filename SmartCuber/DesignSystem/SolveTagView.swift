//
//  SolveTagView.swift
//  SmartCuber
//
//  The small inline pill shown beside a solve — PB (mint), +2 or DNF.
//

import SwiftUI

struct SolveTagView: View {
  let penalty: Penalty
  var isPersonalBest = false

  var body: some View {
    if isPersonalBest {
      pill("PB", color: Theme.mint, background: Theme.mint.opacity(0.10), weight: .semibold)
    } else if penalty == .plusTwo {
      pill("+2", color: Theme.secondary, background: Theme.subtleFillStrong)
    } else if penalty == .dnf {
      pill("DNF", color: Theme.red, background: Theme.red.opacity(0.10), weight: .semibold)
    }
  }

  private func pill(
    _ text: String,
    color: Color,
    background: Color,
    weight: Font.Weight = .medium
  ) -> some View {
    Text(text)
      .font(Theme.sans(10.5, weight: weight))
      .tracking(0.6)
      .foregroundStyle(color)
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background(background, in: RoundedRectangle(cornerRadius: 5))
  }
}
