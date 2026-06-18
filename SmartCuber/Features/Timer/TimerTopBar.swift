//
//  TimerTopBar.swift
//  SmartCuber
//
//  The timer's top bar: a native puzzle-picker menu + session label on the
//  left, the scramble centred, and a native overflow menu on the right.
//  Both menus are system `Menu`s, so they adopt Liquid Glass automatically.
//

import SwiftUI
import UIKit

struct TimerTopBar: View {
  let scramble: String
  let sessionName: String
  @Binding var puzzle: Puzzle
  @Binding var inspectionEnabled: Bool
  let onNewScramble: () -> Void
  let onManualEntry: () -> Void
  let onDeleteLast: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      leading
      Text(scramble)
        .font(Theme.mono(15, weight: .regular))
        .tracking(0.9)
        .foregroundStyle(Theme.secondary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
      overflowMenu
    }
    .padding(.horizontal, 22)
    .padding(.top, 15)
  }

  // ── puzzle picker (left) ──────────────────────────────────
  private var leading: some View {
    HStack(spacing: 9) {
      puzzleMenu
      Rectangle().fill(Theme.hairlineStrong).frame(width: 0.5, height: 13)
      Text(sessionName)
        .font(Theme.sans(13.5, weight: .regular))
        .foregroundStyle(Theme.secondary)
    }
    .fixedSize()
  }

  private var puzzleMenu: some View {
    Menu {
      Picker("Puzzle", selection: $puzzle) {
        ForEach(Puzzle.allCases) { option in
          Text(option.label).tag(option)
        }
      }
      .pickerStyle(.inline)
    } label: {
      HStack(spacing: 5) {
        Text(puzzle.label)
          .font(Theme.sans(14.5, weight: .semibold))
          .foregroundStyle(Theme.text)
        Image(systemName: "chevron.down")
          .font(.system(size: 9, weight: .semibold))
          .foregroundStyle(Theme.secondary)
      }
    }
    .menuStyle(.borderlessButton)
  }

  // ── overflow (right) ──────────────────────────────────────
  private var overflowMenu: some View {
    Menu {
      Button {
        UIPasteboard.general.string = scramble
      } label: {
        Label("Copy scramble", systemImage: "doc.on.doc")
      }
      Button(action: onNewScramble) {
        Label("New scramble", systemImage: "arrow.clockwise")
      }
      Toggle(isOn: $inspectionEnabled) {
        Label("Inspection · 15s", systemImage: "clock")
      }
      Button(action: onManualEntry) {
        Label("Manual entry", systemImage: "pencil")
      }
      Button(role: .destructive, action: onDeleteLast) {
        Label("Delete last solve", systemImage: "trash")
      }
    } label: {
      Image(systemName: "ellipsis")
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(Theme.secondary)
        .frame(width: 28, height: 28)
        .contentShape(Rectangle())
    }
    .menuStyle(.borderlessButton)
  }
}
