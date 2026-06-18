//
//  TimerScreenView.swift
//  SmartCuber
//
//  The decluttered timer: scramble up top, the hero time flanked by two
//  thumb prints, and the tab bar below. Chrome dims while running; the
//  top-bar menus dim the background behind them.
//

import SwiftUI
import UIKit

struct TimerScreenView: View {
  @Bindable var model: TimerViewModel
  @Bindable var settings: TimerSettings
  let sessionName: String
  let onSelectTab: (AppTab) -> Void
  let onDeleteLast: () -> Void

  @State private var isPressing = false
  @State private var menuOpen = false
  @State private var puzzleMenuOpen = false

  private var chromeDim: Double { model.phase == .running ? 0.09 : 1 }
  private var anyMenuOpen: Bool { menuOpen || puzzleMenuOpen }

  var body: some View {
    ZStack {
      Theme.background.ignoresSafeArea()
      ambientWash.ignoresSafeArea()

      VStack(spacing: 0) {
        TimerTopBar(
          scramble: model.scramble,
          puzzleLabel: model.puzzle.label,
          sessionName: sessionName,
          puzzleActive: puzzleMenuOpen,
          menuActive: menuOpen,
          onPuzzleTap: togglePuzzleMenu,
          onMenuTap: toggleOverflowMenu)
        .opacity(chromeDim)
        .animation(.easeInOut(duration: 0.4), value: chromeDim)

        heroRow

        CubeTabBar(active: .timer, dim: chromeDim, onSelect: onSelectTab)
      }

      if anyMenuOpen { scrim }
    }
    .overlay(alignment: .topTrailing) { if menuOpen { overflowMenu } }
    .overlay(alignment: .topLeading) { if puzzleMenuOpen { puzzleMenu } }
  }

  // ── hero row ──────────────────────────────────────────────
  private var heroRow: some View {
    let showPrints = model.phase != .stopped
    return HStack(spacing: 52) {
      if showPrints { FingerTargetView(phase: model.phase) }
      VStack(spacing: 18) {
        HeroTimeView(seconds: heroValue, color: heroColor, size: heroSize)
        hint
      }
      if showPrints { FingerTargetView(phase: model.phase) }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 40)
    .contentShape(Rectangle())
    .gesture(pressGesture)
  }

  private var pressGesture: some Gesture {
    DragGesture(minimumDistance: 0)
      .onChanged { _ in
        guard !anyMenuOpen, !isPressing else { return }
        isPressing = true
        model.pressBegan()
      }
      .onEnded { _ in
        guard isPressing else { return }
        isPressing = false
        model.pressEnded()
      }
  }

  @ViewBuilder private var hint: some View {
    if model.phase == .stopped {
      if model.lastSolveWasPB {
        Text("Personal Best")
          .font(Theme.sans(11, weight: .heavy))
          .tracking(2)
          .foregroundStyle(Theme.mint)
      }
    } else if let text = hintText {
      Text(text)
        .font(Theme.sans(13, weight: model.phase == .idle ? .regular : .semibold))
        .tracking(0.5)
        .foregroundStyle(hintColor)
    }
  }

  // ── menus ─────────────────────────────────────────────────
  private var scrim: some View {
    Color.black.opacity(0.4)
      .ignoresSafeArea()
      .onTapGesture { closeMenus() }
  }

  private var overflowMenu: some View {
    OverflowMenuView(
      inspectionEnabled: settings.inspectionEnabled,
      onCopyScramble: { UIPasteboard.general.string = model.scramble; closeMenus() },
      onNewScramble: { model.regenerateScramble(); closeMenus() },
      onToggleInspection: { settings.inspectionEnabled.toggle() },
      onManualEntry: { closeMenus() },
      onDeleteLast: { onDeleteLast(); closeMenus() })
    .padding(.top, 44)
    .padding(.trailing, 18)
  }

  private var puzzleMenu: some View {
    PuzzleMenuView(current: model.puzzle) { puzzle in
      model.puzzle = puzzle
      closeMenus()
    }
    .padding(.top, 42)
    .padding(.leading, 18)
  }

  @ViewBuilder private var ambientWash: some View {
    if let ambientColor {
      RadialGradient(
        colors: [ambientColor.opacity(model.phase == .holding ? 0.12 : 0.18), .clear],
        center: UnitPoint(x: 0.5, y: 0.46),
        startRadius: 0,
        endRadius: 460)
      .animation(.easeInOut(duration: 0.4), value: model.phase)
    }
  }

  // ── derived values ────────────────────────────────────────
  private var heroValue: Double {
    switch model.phase {
    case .idle, .holding, .ready: return 0
    default: return model.elapsedSeconds
    }
  }

  private var heroSize: CGFloat { model.phase == .running ? 100 : 90 }

  private var heroColor: Color {
    switch model.phase {
    case .holding: return Theme.red
    case .ready: return Theme.mint
    case .stopped: return model.lastSolveWasPB ? Theme.mint : Theme.text
    default: return Theme.text
    }
  }

  private var ambientColor: Color? {
    switch model.phase {
    case .holding: return Theme.red
    case .ready: return Theme.mint
    case .stopped where model.lastSolveWasPB: return Theme.mint
    default: return nil
    }
  }

  private var hintText: String? {
    switch model.phase {
    case .idle: return "Hold both prints to start"
    case .holding: return "Keep holding…"
    case .ready: return "Release to start"
    case .running: return "Place both fingers to stop"
    case .stopped: return nil
    }
  }

  private var hintColor: Color {
    switch model.phase {
    case .holding: return Theme.red
    case .ready: return Theme.mint
    case .running: return Theme.secondary
    default: return Theme.tertiary
    }
  }

  // ── menu toggles ──────────────────────────────────────────
  // Only one menu is ever open at a time.
  private func toggleOverflowMenu() {
    let willOpen = !menuOpen
    closeMenus()
    menuOpen = willOpen
  }

  private func togglePuzzleMenu() {
    let willOpen = !puzzleMenuOpen
    closeMenus()
    puzzleMenuOpen = willOpen
  }

  private func closeMenus() {
    menuOpen = false
    puzzleMenuOpen = false
  }
}
