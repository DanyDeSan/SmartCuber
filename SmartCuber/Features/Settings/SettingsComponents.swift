//
//  SettingsComponents.swift
//  SmartCuber
//
//  Shared building blocks for the Settings tab: a grouped card and the row
//  inside it. Split out of SettingsScreenView as the row gained more accessory
//  shapes (toggle, detail text, slider, share link, native picker).
//

import SwiftUI

/// An inset, grouped settings card with a small uppercased title.
struct SettingsGroup<Content: View>: View {
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
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14))
    }
  }
}

/// A single settings row: icon tile, title (+ optional subtitle), and either
/// a trailing detail value, a custom accessory, or a disclosure chevron.
/// An optional `expanded` slot renders full-width below the row, for
/// accessories (like a slider) too wide to share the row with the label.
struct SettingsRow<Trailing: View, Expanded: View>: View {
  let icon: String
  let label: String
  var sub: String?
  var detail: String?
  var showChevron = false
  var isLast = false
  @ViewBuilder var trailing: () -> Trailing
  @ViewBuilder var expanded: () -> Expanded

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 13) {
        Image(systemName: icon)
          .font(.system(size: 14, weight: .medium))
          .foregroundStyle(Theme.text)
          .frame(width: 30, height: 30)
          .background(Theme.subtleFillStrong, in: RoundedRectangle(cornerRadius: 8))
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
      if Expanded.self != EmptyView.self {
        expanded()
          .padding(.horizontal, 16)
          .padding(.bottom, 14)
      }
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

extension SettingsRow where Trailing == EmptyView, Expanded == EmptyView {
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
      trailing: { EmptyView() },
      expanded: { EmptyView() })
  }
}

extension SettingsRow where Expanded == EmptyView {
  init(
    icon: String,
    label: String,
    sub: String? = nil,
    detail: String? = nil,
    showChevron: Bool = false,
    isLast: Bool = false,
    @ViewBuilder trailing: @escaping () -> Trailing
  ) {
    self.init(
      icon: icon,
      label: label,
      sub: sub,
      detail: detail,
      showChevron: showChevron,
      isLast: isLast,
      trailing: trailing,
      expanded: { EmptyView() })
  }
}

extension SettingsRow where Trailing == EmptyView {
  init(
    icon: String,
    label: String,
    sub: String? = nil,
    detail: String? = nil,
    isLast: Bool = false,
    @ViewBuilder expanded: @escaping () -> Expanded
  ) {
    self.init(
      icon: icon,
      label: label,
      sub: sub,
      detail: detail,
      showChevron: false,
      isLast: isLast,
      trailing: { EmptyView() },
      expanded: expanded)
  }
}
