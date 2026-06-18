// StatusBarSwiftUI.swift
// Gridex
//
// SwiftUI bottom status bar.

import SwiftUI

struct StatusBarSwiftUIView: View {
    @EnvironmentObject private var appState: AppState
    @State private var themeVersion = 0

    var body: some View {
        let _ = themeVersion
        HStack(spacing: 0) {
            statusItem(appState.statusConnection ?? "Not connected")
            separator
            statusItem(appState.statusSchema ?? "")
            separator
            statusItem(appState.statusRowCount.map { "\($0) rows" } ?? "")
            separator
            statusItem(appState.statusQueryTime.map { "\(Int($0 * 1000))ms" } ?? "")

            if let dbSize = appState.redisDBSize {
                separator
                statusItem("\(dbSize) keys")
            }

            Spacer()

            statusItem("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0")")
        }
        .padding(.horizontal, 8)
        .frame(height: 24)
        .background(Color(nsColor: .windowBackgroundColor))
        .overlay(alignment: .top) { Divider() }
        .onReceive(NotificationCenter.default.publisher(for: .themeDidChange)) { _ in
            themeVersion += 1
        }
    }

    private func statusItem(_ text: String) -> some View {
        Text(text)
            .font(.system(size: GridexTheme.FontSize.ui - 1))
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }

    private var separator: some View {
        Text("|")
            .font(.system(size: GridexTheme.FontSize.ui - 1))
            .foregroundStyle(.quaternary)
            .padding(.horizontal, 6)
    }
}
