//
//  QuizSettingsView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct QuizSettingsView: View {
    @State private var questionCount = 10
    @State private var selectedCategory = "General Knowledge"
    @State private var isHardMode = false

    let categories = ["General Knowledge", "Science", "History", "Sports", "Music"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {

                Text("Quiz Settings")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)

                CategoryPicker(selectedCategory: $selectedCategory, categories: categories)

                Stepper("Questions: \(questionCount)", value: $questionCount, in: 5...20)

                HardModeToggle(isHardMode: $isHardMode)

                Spacer()

                StartButton {
                    print("Start quiz with:")
                    print("Category: \(selectedCategory)")
                    print("Questions: \(questionCount)")
                    print("Hard Mode: \(isHardMode)")
                }
            }
            .padding()
        }
    }
}

#Preview {
    QuizSettingsView()
}
