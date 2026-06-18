//
//  OverflowMenuView.swift
//  SmartCuber
//
//  The ••• overflow menu: scramble actions, inspection toggle, manual entry
//  and a destructive "delete last solve".
//

import SwiftUI

struct OverflowMenuView: View {
  let inspectionEnabled: Bool
  let onCopyScramble: () -> Void
  let onNewScramble: () -> Void
  let onToggleInspection: () -> Void
  let onManualEntry: () -> Void
  let onDeleteLast: () -> Void

  var body: some View {
    VStack(spacing: 0) {
      row(icon: "doc.on.doc", label: "Copy scramble", action: onCopyScramble)
      divider
      row(icon: "arrow.clockwise", label: "New scramble", action: onNewScramble)
      divider
      row(
        icon: "clock",
        label: "Inspection · 15s",
        isChecked: inspectionEnabled,
        action: onToggleInspection)
      divider
      row(icon: "pencil", label: "Manual entry", action: onManualEntry)
      divider
      row(icon: "trash", label: "Delete last solve", danger: true, action: onDeleteLast)
    }
    .frame(width: 238)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    .overlay(
      RoundedRectangle(cornerRadius: 16).strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5))
    .shadow(color: .black.opacity(0.55), radius: 30, y: 24)
  }

  private var divider: some View {
    Rectangle().fill(Theme.hairline).frame(height: 0.5)
  }

  private func row(
    icon: String,
    label: String,
    danger: Bool = false,
    isChecked: Bool = false,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      HStack(spacing: 13) {
        Image(systemName: icon)
          .font(.system(size: 15, weight: .medium))
          .foregroundStyle(danger ? Theme.red : Theme.text)
          .frame(width: 18)
        Text(label)
          .font(Theme.sans(14.5, weight: .regular))
          .foregroundStyle(danger ? Theme.red : Theme.text)
        Spacer(minLength: 0)
        if isChecked {
          Image(systemName: "checkmark")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(Theme.mint)
        }
      }
      .padding(.horizontal, 15)
      .frame(height: 44)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}
