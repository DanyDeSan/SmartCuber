//
//  TimerScreenView.swift
//  SmartCuber
//
//  The decluttered timer: scramble up top, the hero time flanked by two
//  thumb prints. Arming requires *two* simultaneous touches. The system tab
//  bar hides while running for an immersive, full-screen solve.
//

import SwiftUI

struct TimerScreenView: View {
  @Bindable var model: TimerViewModel
  @Bindable var settings: TimerSettings
  let sessionName: String
  let onDeleteLast: () -> Void

  var body: some View {
    ZStack {
      Theme.background.ignoresSafeArea()
      ambientWash.ignoresSafeArea()

      VStack(spacing: 0) {
        TimerTopBar(
          scramble: model.scramble,
          sessionName: sessionName,
          puzzle: $model.puzzle,
          inspectionEnabled: $settings.inspectionEnabled,
          onNewScramble: model.regenerateScramble,
          onManualEntry: {},
          onDeleteLast: onDeleteLast)
        .opacity(chromeDim)
        .animation(.easeInOut(duration: 0.4), value: chromeDim)

        heroRow
      }
    }
    .toolbar(model.phase == .running ? .hidden : .automatic, for: .tabBar)
    .animation(.easeInOut(duration: 0.3), value: model.phase == .running)
  }

  private var chromeDim: Double { model.phase == .running ? 0.09 : 1 }

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
    .overlay(touchSurface)
  }

  /// Arms on two simultaneous touches, releases when fewer than two remain.
  private var touchSurface: some View {
    TwoFingerTouchSurface { isDown in
      if isDown {
        model.pressBegan()
      } else {
        model.pressEnded()
      }
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
}
