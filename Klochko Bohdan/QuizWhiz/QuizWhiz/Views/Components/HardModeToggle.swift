//
//  HardModeToggle.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct HardModeToggle: View {
    @Binding var isHardMode: Bool

    var body: some View {
        Toggle(isOn: $isHardMode) {
            Text("Hard Mode")
                .font(.headline)
        }
        .toggleStyle(SwitchToggleStyle(tint: .red))
    }
}

