//
//  TimerSettings.swift
//  SmartCuber
//
//  Observable, UserDefaults-backed preferences surfaced on the Settings tab.
//  Reactive state via Observation; no Combine. See [[project_no_combine]].
//

import Foundation
import Observation

@Observable
final class TimerSettings {
  /// How a solve is armed. Display-only for now ("Two fingers").
  var startTrigger: String

  /// Seconds both prints must be held before the timer arms.
  var holdToArmSeconds: Double {
    didSet { defaults.set(holdToArmSeconds, forKey: Keys.holdToArm) }
  }

  /// Whether the WCA 15-second inspection countdown is offered.
  var inspectionEnabled: Bool {
    didSet { defaults.set(inspectionEnabled, forKey: Keys.inspection) }
  }

  /// Whether haptic feedback fires on arm / ready / stop.
  var hapticsEnabled: Bool {
    didSet { defaults.set(hapticsEnabled, forKey: Keys.haptics) }
  }

  /// The typeface family applied to every time/scramble/stat readout.
  var timerFont: TimerFont {
    didSet { defaults.set(timerFont.rawValue, forKey: Keys.timerFont) }
  }

  /// The active appearance override. "System" (the default) means the app
  /// just follows the device's light/dark setting.
  var appearance: AppAppearance {
    didSet { defaults.set(appearance.rawValue, forKey: Keys.appearance) }
  }

  @ObservationIgnored private let defaults: UserDefaults

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
    self.startTrigger = "Two fingers"
    self.holdToArmSeconds = defaults.object(forKey: Keys.holdToArm) as? Double ?? 0.55
    self.inspectionEnabled = defaults.object(forKey: Keys.inspection) as? Bool ?? true
    self.hapticsEnabled = defaults.object(forKey: Keys.haptics) as? Bool ?? true
    let storedFont = defaults.string(forKey: Keys.timerFont).flatMap(TimerFont.init(rawValue:))
    self.timerFont = storedFont ?? .systemMono
    let storedAppearance =
      defaults.string(forKey: Keys.appearance).flatMap(AppAppearance.init(rawValue:))
    self.appearance = storedAppearance ?? .system
  }

  /// Hold duration formatted for the row detail, e.g. "0.55 s".
  var holdToArmLabel: String {
    String(format: "%.2f s", holdToArmSeconds)
  }

  private enum Keys {
    static let holdToArm = "settings.holdToArmSeconds"
    static let inspection = "settings.inspectionEnabled"
    static let haptics = "settings.hapticsEnabled"
    static let timerFont = "settings.timerFont"
    static let appearance = "settings.appearance"
  }
}
