//
//  StatCardView.swift
//  SmartCuber
//
//  A single average card (best / ao5 / ao12 / ao50 / mean / solves).
//

import SwiftUI

struct StatCardView: View {
  let label: String
  let value: String
  var accent = false

  var body: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text(label.uppercased())
        .font(Theme.sans(10, weight: .semibold))
        .tracking(1)
        .foregroundStyle(Theme.tertiary)
      Text(value)
        .font(Theme.mono(22, weight: .medium))
        .foregroundStyle(accent ? Theme.mint : Theme.text)
        .lineLimit(1)
        .minimumScaleFactor(0.6)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 14)
    .padding(.vertical, 12)
    .background(Theme.surface, in: RoundedRectangle(cornerRadius: 14))
    .overlay(
      RoundedRectangle(cornerRadius: 14).strokeBorder(Theme.hairline, lineWidth: 0.5))
  }
}
