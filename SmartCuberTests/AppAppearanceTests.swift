//
//  AppAppearanceTests.swift
//  SmartCuberTests
//

@testable import SmartCuber
import SwiftUI
import Testing

struct AppAppearanceTests {
  @Test func rawValueRoundTripsForEveryCase() {
    for appearance in AppAppearance.allCases {
      #expect(AppAppearance(rawValue: appearance.rawValue) == appearance)
    }
  }

  @Test func systemMeansNoColorSchemeOverride() {
    #expect(AppAppearance.system.colorScheme == nil)
  }

  @Test func lightAndDarkMapToTheMatchingColorScheme() {
    #expect(AppAppearance.light.colorScheme == .light)
    #expect(AppAppearance.dark.colorScheme == .dark)
  }
}
