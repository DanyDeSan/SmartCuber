//
//  CubeTabBar.swift
//  SmartCuber
//
//  The shared bottom tab bar. Dims toward invisible while the timer runs.
//

import SwiftUI

struct CubeTabBar: View {
  let active: AppTab
  var dim: Double = 1
  let onSelect: (AppTab) -> Void

  var body: some View {
    HStack(spacing: 56) {
      ForEach(AppTab.allCases) { tab in
        Button {
          onSelect(tab)
        } label: {
          tabLabel(tab)
        }
        .buttonStyle(.plain)
        .disabled(dim < 0.5)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 9)
    .padding(.bottom, 12)
    .overlay(alignment: .top) {
      Rectangle().fill(Theme.hairline).frame(height: 0.5)
    }
    .background(Theme.background.opacity(0.7))
    .opacity(dim)
    .animation(.easeInOut(duration: 0.4), value: dim)
  }

  private func tabLabel(_ tab: AppTab) -> some View {
    let color = tab == active ? Theme.mint : Theme.tertiary
    return VStack(spacing: 3.5) {
      Image(systemName: tab.systemImage)
        .font(.system(size: 18, weight: .medium))
      Text(tab.title)
        .font(Theme.sans(10, weight: .medium))
    }
    .foregroundStyle(color)
  }
}
