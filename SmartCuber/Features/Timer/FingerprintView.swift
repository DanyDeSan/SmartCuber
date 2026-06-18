//
//  FingerprintView.swift
//  SmartCuber
//
//  The concentric-arc fingerprint glyph that flanks the hero time. Ported
//  arc-for-arc from the design's inline SVG (a 24×24 viewBox), scaled to
//  the requested size.
//

import SwiftUI

struct FingerprintView: View {
  var color: Color
  var size: CGFloat = 50

  var body: some View {
    FingerprintShape()
      .stroke(color, style: StrokeStyle(lineWidth: 1.4 * size / 24, lineCap: .round))
      .frame(width: size, height: size)
  }
}

/// The six fingerprint arcs in a 24×24 coordinate space.
private struct FingerprintShape: Shape {
  func path(in rect: CGRect) -> Path {
    let scale = min(rect.width, rect.height) / 24
    var path = Path()
    for arc in Self.arcs {
      path.move(to: arc.start)
      path.addCurve(to: arc.end, control1: arc.control1, control2: arc.control2)
      path.addLine(to: arc.tail)
    }
    return path.applying(CGAffineTransform(scaleX: scale, y: scale))
  }

  /// Each arc: a cubic from `start` to `end`, then a vertical line to `tail`.
  private struct Arc {
    let start: CGPoint
    let control1: CGPoint
    let control2: CGPoint
    let end: CGPoint
    let tail: CGPoint

    /// Builds an arc from flat coordinate pairs to keep the table compact.
    init(_ values: [Double]) {
      start = CGPoint(x: values[0], y: values[1])
      control1 = CGPoint(x: values[2], y: values[3])
      control2 = CGPoint(x: values[4], y: values[5])
      end = CGPoint(x: values[6], y: values[7])
      tail = CGPoint(x: values[8], y: values[9])
    }
  }

  // Coordinate pairs: start, control1, control2, end, tail — in the 24×24 box.
  private static let arcs: [Arc] = [
    Arc([12, 4, 7.6, 4, 4, 7.6, 4, 12, 4, 17]),     // left outer
    Arc([12, 7, 9.2, 7, 7, 9.2, 7, 12, 7, 17]),     // left middle
    Arc([12, 10, 10.9, 10, 10, 10.9, 10, 12, 10, 18]),  // left inner
    Arc([12, 4, 16.4, 4, 20, 7.6, 20, 12, 20, 15]),     // right outer
    Arc([12, 7, 14.8, 7, 17, 9.2, 17, 12, 17, 16]),     // right middle
    Arc([12, 10, 13.1, 10, 14, 10.9, 14, 12, 14, 17])  // right inner
  ]
}
