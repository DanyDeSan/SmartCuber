//
//  FingerTargetView.swift
//  SmartCuber
//
//  One of the two thumb targets flanking the hero time. Its colour and the
//  surrounding pulse ring carry the timer's state ritual.
//

import SwiftUI

struct FingerTargetView: View {
  let phase: TimerPhase

  private var isArmed: Bool { phase == .holding || phase == .ready }
  private var isStop: Bool { phase == .running }
  private var isInspecting: Bool { phase == .inspecting }

  private var color: Color {
    switch phase {
    case .holding: return Theme.red
    case .ready: return Theme.mint
    case .inspecting: return Theme.amber
    case .running: return Theme.secondary
    default: return Theme.tertiary
    }
  }

  private var fillOpacity: Double {
    if isArmed { return 0.12 }
    if isStop || isInspecting { return 0.05 }
    return 0.03
  }

  private var borderOpacity: Double {
    if isArmed { return 0.36 }
    if isStop || isInspecting { return 0.19 }
    return 0.09
  }

  var body: some View {
    ZStack {
      if isArmed {
        Circle()
          .strokeBorder(color.opacity(0.18), lineWidth: 1.5)
          .padding(-9)
      }
      Circle()
        .fill((isArmed ? color : Theme.subtleFillBase).opacity(fillOpacity))
        .overlay(Circle().strokeBorder(color.opacity(borderOpacity), lineWidth: 1.5))
      FingerprintView(color: color, size: 50)
    }
    .frame(width: 90, height: 90)
    .animation(.easeOut(duration: 0.18), value: phase)
  }
}
