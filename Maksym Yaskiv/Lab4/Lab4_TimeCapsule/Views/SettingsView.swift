//
//  SettingsView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 23.11.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Section(header: Text("Font Settings")) {
                Text("Size: \(Int(viewModel.fontSize))")
                FontSizeSlider(value: $viewModel.fontSize, range: 12...24)
                    .frame(height: 40)
            }
        }
        .navigationTitle("Settings")
    }
}