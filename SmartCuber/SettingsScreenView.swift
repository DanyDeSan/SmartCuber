//
//  SettingsScreenView.swift
//  SmartCuber
//
//  The Settings tab: a grouped, two-column layout. Timer & Display on the
//  left; Sessions & Data and About on the right.
//

import SwiftUI

struct SettingsScreenView: View {
  @Bindable var settings: TimerSettings
  let sessionCount: Int
  let onSelectTab: (AppTab) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("Settings")
        .font(Theme.sans(21, weight: .bold))
        .foregroundStyle(Theme.text)
        .padding(.horizontal, 28)
        .padding(.top, 17)

      HStack(alignment: .top, spacing: 22) {
        leftColumn
        rightColumn
      }
      .padding(.horizontal, 28)
      .padding(.top, 12)

      Spacer(minLength: 0)
      CubeTabBar(active: .settings, onSelect: onSelectTab)
    }
    .padding(.leading, 46)
    .background(Theme.background.ignoresSafeArea())
  }

  private var leftColumn: some View {
    VStack(spacing: 16) {
      SettingsGroup(title: "Timer") {
        SettingsRow(
          icon: "hand.point.up.fill", label: "Start trigger", detail: settings.startTrigger)
        SettingsRow(icon: "clock", label: "Hold to arm", detail: settings.holdToArmLabel)
        SettingsRow(icon: "clock", label: "Inspection", sub: "WCA 15-second countdown") {
          toggle($settings.inspectionEnabled)
        }
        SettingsRow(
          icon: "waveform", label: "Haptic feedback", sub: "Arm · ready · stop", isLast: true) {
          toggle($settings.hapticsEnabled)
        }
      }
      SettingsGroup(title: "Display") {
        SettingsRow(icon: "textformat", label: "Timer font", detail: settings.timerFont)
        SettingsRow(icon: "moon", label: "Appearance", detail: settings.appearance, isLast: true)
      }
    }
    .frame(maxWidth: .infinity)
  }

  private var rightColumn: some View {
    VStack(spacing: 16) {
      SettingsGroup(title: "Sessions & data") {
        SettingsRow(
          icon: "folder",
          label: "Manage sessions",
          sub: "\(sessionCount) session\(sessionCount == 1 ? "" : "s")",
          showChevron: true)
        SettingsRow(
          icon: "square.and.arrow.up",
          label: "Export solves",
          sub: "CSV · csTimer",
          showChevron: true,
          isLast: true)
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
}

/// An inset, grouped settings card with a small uppercased title.
private struct SettingsGroup<Content: View>: View {
  let title: String
  @ViewBuilder let content: Content

  var body: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text(title.uppercased())
        .font(Theme.sans(10, weight: .semibold))
        .tracking(1)
        .foregroundStyle(Theme.tertiary)
        .padding(.horizontal, 4)
      VStack(spacing: 0) { content }
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
          RoundedRectangle(cornerRadius: 14).strokeBorder(Theme.hairline, lineWidth: 0.5))
    }
  }
}

/// A single settings row: icon tile, title (+ optional subtitle), and either
/// a trailing detail value, a custom accessory, or a disclosure chevron.
private struct SettingsRow<Trailing: View>: View {
  let icon: String
  let label: String
  var sub: String?
  var detail: String?
  var showChevron = false
  var isLast = false
  @ViewBuilder var trailing: () -> Trailing

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 13) {
        Image(systemName: icon)
          .font(.system(size: 14, weight: .medium))
          .foregroundStyle(Theme.text)
          .frame(width: 30, height: 30)
          .background(Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
        VStack(alignment: .leading, spacing: 1) {
          Text(label)
            .font(Theme.sans(14.5, weight: .regular))
            .foregroundStyle(Theme.text)
          if let sub {
            Text(sub)
              .font(Theme.sans(11.5, weight: .regular))
              .foregroundStyle(Theme.tertiary)
          }
        }
        Spacer(minLength: 0)
        accessory
      }
      .padding(.horizontal, 16)
      .frame(minHeight: 50)
      if !isLast {
        Rectangle().fill(Theme.hairline).frame(height: 0.5)
      }
    }
  }

  @ViewBuilder private var accessory: some View {
    if let detail {
      HStack(spacing: 5) {
        Text(detail)
          .font(Theme.sans(13.5, weight: .regular))
          .foregroundStyle(Theme.secondary)
        chevron
      }
    } else if showChevron {
      chevron
    } else {
      trailing()
    }
  }

  private var chevron: some View {
    Image(systemName: "chevron.right")
      .font(.system(size: 12, weight: .semibold))
      .foregroundStyle(Theme.tertiary)
  }
}

extension SettingsRow where Trailing == EmptyView {
  init(
    icon: String,
    label: String,
    sub: String? = nil,
    detail: String? = nil,
    showChevron: Bool = false,
    isLast: Bool = false
  ) {
    self.init(
      icon: icon,
      label: label,
      sub: sub,
      detail: detail,
      showChevron: showChevron,
      isLast: isLast,
      trailing: { EmptyView() })
  }
}
