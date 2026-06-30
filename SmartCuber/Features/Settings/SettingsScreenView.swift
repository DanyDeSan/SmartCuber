//
//  SettingsScreenView.swift
//  SmartCuber
//
//  The Settings tab: a grouped, two-column layout. Timer & Display on the
//  left; Sessions & Data and About on the right.
//

import SwiftData
import SwiftUI

struct SettingsScreenView: View {
  @Query(sort: \Solve.date, order: .reverse) private var solves: [Solve]

  @Bindable var settings: TimerSettings
  let sessionCount: Int
  let onManageSessions: () -> Void

  @State private var isChoosingAppearance = false

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Settings")
        .font(Theme.sans(21, weight: .bold))
        .foregroundStyle(Theme.text)
        .padding(.horizontal, 28)
        .padding(.top, 17)

      // Multiple self-sizing controls (Slider, Menu) on this screen can
      // make SwiftUI misjudge the columns' intrinsic height in a fixed
      // VStack, clipping content above the fold. A ScrollView makes the
      // page resilient to that regardless of the exact cause.
      ScrollView(showsIndicators: false) {
        HStack(alignment: .top, spacing: 22) {
          leftColumn
          rightColumn
        }
        .padding(.horizontal, 28)
        .padding(.top, 12)
        .padding(.bottom, 17)
      }
    }
    .background(Theme.background.ignoresSafeArea())
    .confirmationDialog("Appearance", isPresented: $isChoosingAppearance) {
      ForEach(AppAppearance.allCases) { option in
        Button(option.label) { settings.appearance = option }
      }
    }
  }

  private var leftColumn: some View {
    VStack(spacing: 16) {
      SettingsGroup(title: "Timer") {
        SettingsRow(
          icon: "hand.point.up.fill", label: "Start trigger", detail: settings.startTrigger)
        SettingsRow(
          icon: "clock",
          label: "Hold to arm",
          sub: settings.holdToArmLabel,
          expanded: { holdToArmSlider })
        SettingsRow(icon: "clock", label: "Inspection", sub: "WCA 15-second countdown") {
          toggle($settings.inspectionEnabled)
        }
        SettingsRow(
          icon: "waveform", label: "Haptic feedback", sub: "Arm · ready · stop", isLast: true) {
          toggle($settings.hapticsEnabled)
        }
      }
      SettingsGroup(title: "Display") {
        SettingsRow(icon: "textformat", label: "Timer font") {
          fontMenu
        }
        Button {
          isChoosingAppearance = true
        } label: {
          SettingsRow(
            icon: "moon", label: "Appearance", detail: settings.appearance.label, isLast: true)
        }
        .buttonStyle(.plain)
      }
    }
    .frame(maxWidth: .infinity)
  }

  private var rightColumn: some View {
    VStack(spacing: 16) {
      SettingsGroup(title: "Sessions & data") {
        Button(action: onManageSessions) {
          SettingsRow(
            icon: "folder",
            label: "Manage sessions",
            sub: "\(sessionCount) session\(sessionCount == 1 ? "" : "s")",
            showChevron: true)
        }
        .buttonStyle(.plain)
        SettingsRow(
          icon: "square.and.arrow.up",
          label: "Export solves",
          sub: "CSV · csTimer",
          isLast: true
        ) {
          exportShareLink
        }
      }
      SettingsGroup(title: "About") {
        SettingsRow(icon: "info.circle", label: "Version", isLast: true) {
          Text("1.0 (24)")
            .font(Theme.mono(13))
            .foregroundStyle(Theme.tertiary)
        }
      }
    }
    .frame(maxWidth: .infinity)
  }

  private func toggle(_ binding: Binding<Bool>) -> some View {
    Toggle("", isOn: binding)
      .labelsHidden()
      .tint(Theme.mint)
      .scaleEffect(0.82)
  }

  private var holdToArmSlider: some View {
    Slider(value: $settings.holdToArmSeconds, in: 0.1...2.0, step: 0.05)
      .tint(Theme.mint)
  }

  /// Writes the current CSV export to a temp file with a real `.csv` name,
  /// so the system share sheet treats it as an actual file attachment
  /// rather than a plain-text blob. `nil` if the write fails.
  private var exportFileURL: URL? {
    let csv = SolveCSVExporter.csv(for: solves)
    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent("SmartCuber-Solves.csv")
    do {
      try csv.write(to: url, atomically: true, encoding: .utf8)
      return url
    } catch {
      return nil
    }
  }

  @ViewBuilder private var exportShareLink: some View {
    if let url = exportFileURL {
      ShareLink(item: url) { chevron }
    } else {
      chevron
    }
  }

  private var chevron: some View {
    Image(systemName: "chevron.right")
      .font(.system(size: 12, weight: .semibold))
      .foregroundStyle(Theme.tertiary)
  }

  private var fontMenu: some View {
    pickerMenu(label: "Timer font", selection: $settings.timerFont, options: TimerFont.allCases) {
      $0.label
    }
  }

  /// A compact `Menu`/inline-`Picker` accessory, styled like the row's own
  /// `detail` text + chevron — the same pattern `TimerTopBar.puzzleMenu` uses.
  private func pickerMenu<Option: Identifiable & Hashable>(
    label: String,
    selection: Binding<Option>,
    options: [Option],
    display: @escaping (Option) -> String
  ) -> some View {
    Menu {
      Picker(label, selection: selection) {
        ForEach(options) { option in
          Text(display(option)).tag(option)
        }
      }
      .pickerStyle(.inline)
    } label: {
      HStack(spacing: 5) {
        Text(display(selection.wrappedValue))
          .font(Theme.sans(13.5, weight: .regular))
          .foregroundStyle(Theme.secondary)
        Image(systemName: "chevron.right")
          .font(.system(size: 12, weight: .semibold))
          .foregroundStyle(Theme.tertiary)
      }
    }
    .menuStyle(.borderlessButton)
  }
}
