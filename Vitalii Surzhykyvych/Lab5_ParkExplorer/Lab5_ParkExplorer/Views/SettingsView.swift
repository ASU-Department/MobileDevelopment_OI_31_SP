//
//  SettingsView.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage("notificationsEnabled")
    private var notificationsEnabled: Bool = true

    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Toggle("Enable park alerts", isOn: $notificationsEnabled)
            }

            Section(header: Text("About")) {
                Text("ParkExplorer v1.0")
                Text("National Parks Guide")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
