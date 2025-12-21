//
//  SettingsView.swift
//  ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true

    var body: some View {
        Form {
            Toggle("Enable park alerts", isOn: $notificationsEnabled)

            Section {
                Text("ParkExplorer v1.0")
                Text("National Parks Guide")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
