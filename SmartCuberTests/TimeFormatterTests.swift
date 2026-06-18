//
//  TimeFormatterTests.swift
//  SmartCuberTests
//

@testable import SmartCuber
import Testing

struct TimeFormatterTests {

  @Test func subMinuteFormatsWithCentiseconds() {
    #expect(TimeFormatter.string(seconds: 9.61) == "9.61")
  }

  @Test func zeroFormatsAsBaseline() {
    #expect(TimeFormatter.string(seconds: 0) == "0.00")
  }

  @Test func overMinuteFormatsWithColon() {
    #expect(TimeFormatter.string(seconds: 83.45) == "1:23.45")
  }

  @Test func componentsSplitWholeAndFraction() {
    let components = TimeFormatter.components(seconds: 9.04)
    #expect(components.whole == "9")
    #expect(components.fraction == "04")
    #expect(components.big == "9.04")
  }

  @Test func centisecondsAreClampedNotRoundedToSixty() {
    // 59.999s must not round up into "60" seconds territory.
    #expect(TimeFormatter.string(seconds: 59.999) == "59.99")
  }
}
