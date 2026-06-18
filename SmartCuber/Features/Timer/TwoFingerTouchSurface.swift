//
//  TwoFingerTouchSurface.swift
//  SmartCuber
//
//  A transparent multitouch surface that reports when *two or more* fingers
//  are down vs. fewer than two. The timer arms only on a genuine two-thumb
//  hold — a single touch never starts or stops it.
//

import SwiftUI
import UIKit

struct TwoFingerTouchSurface: UIViewRepresentable {
  /// Called with `true` once two fingers are registered, and `false` once
  /// fewer than two remain.
  let onTwoFingerChange: (Bool) -> Void

  func makeUIView(context: Context) -> TrackingView {
    let view = TrackingView()
    view.isMultipleTouchEnabled = true
    view.backgroundColor = .clear
    view.onChange = onTwoFingerChange
    return view
  }

  func updateUIView(_ uiView: TrackingView, context: Context) {
    uiView.onChange = onTwoFingerChange
  }

  final class TrackingView: UIView {
    var onChange: ((Bool) -> Void)?
    private var twoFingersDown = false

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      updateState(with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      updateState(with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      updateState(with: event)
    }

    private func updateState(with event: UIEvent?) {
      let active = (event?.allTouches ?? []).filter {
        $0.phase != .ended && $0.phase != .cancelled
      }
      let isDown = active.count >= 2
      guard isDown != twoFingersDown else { return }
      twoFingersDown = isDown
      onChange?(isDown)
    }
  }
}
