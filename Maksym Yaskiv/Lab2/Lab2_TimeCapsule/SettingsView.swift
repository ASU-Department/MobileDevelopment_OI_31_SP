//
//  SettingsView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 23.11.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var fontSize: Double

    var body: some View {
        Form {
            Section(header: Text("Font Settings")) {
                Text("Size: \(Int(fontSize))")
                FontSizeSlider(value: $fontSize, range: 12...24)
                    .frame(height: 40)
            }
        }
        .navigationTitle("Settings")
    }
}