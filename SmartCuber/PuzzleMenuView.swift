//
//  PuzzleMenuView.swift
//  SmartCuber
//
//  The puzzle picker dropping from the 3×3 chip. The active puzzle is mint
//  with a trailing checkmark.
//

import SwiftUI

struct PuzzleMenuView: View {
  let current: Puzzle
  let onSelect: (Puzzle) -> Void

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(Puzzle.allCases.enumerated()), id: \.element.id) { index, puzzle in
        Button {
          onSelect(puzzle)
        } label: {
          row(for: puzzle)
        }
        .buttonStyle(.plain)
        if index < Puzzle.allCases.count - 1 {
          Rectangle().fill(Theme.hairline).frame(height: 0.5)
        }
      }
    }
    .frame(width: 206)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    .overlay(
      RoundedRectangle(cornerRadius: 16).strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5))
    .shadow(color: .black.opacity(0.55), radius: 30, y: 24)
  }

  private func row(for puzzle: Puzzle) -> some View {
    let isOn = puzzle == current
    return HStack(spacing: 12) {
      Text(puzzle.label)
        .font(Theme.mono(14, weight: isOn ? .semibold : .regular))
        .foregroundStyle(isOn ? Theme.mint : Theme.text)
      Spacer(minLength: 0)
      if isOn {
        Image(systemName: "checkmark")
          .font(.system(size: 12, weight: .bold))
          .foregroundStyle(Theme.mint)
      }
    }
    .padding(.horizontal, 15)
    .frame(height: 40)
    .background(isOn ? Theme.mint.opacity(0.06) : .clear)
    .contentShape(Rectangle())
  }
}
