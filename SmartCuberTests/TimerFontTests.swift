//
//  TimerFontTests.swift
//  SmartCuberTests
//

@testable import SmartCuber
import SwiftUI
import Testing

struct TimerFontTests {
  @Test func rawValueRoundTripsForEveryCase() {
    for font in TimerFont.allCases {
      #expect(TimerFont(rawValue: font.rawValue) == font)
    }
  }

  @Test func designMappingMatchesEachCase() {
    #expect(TimerFont.systemMono.design == .monospaced)
    #expect(TimerFont.rounded.design == .rounded)
    #expect(TimerFont.classic.design == .serif)
  }

  @Test func labelsAreUnique() {
    let labels = Set(TimerFont.allCases.map(\.label))
    #expect(labels.count == TimerFont.allCases.count)
  }
}
