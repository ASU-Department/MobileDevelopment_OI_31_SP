//
//  QuizSettingsView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct QuizSettingsView: View {
    @State private var questionCount = 10
    @State private var selectedCategory: Category = categories.first!
    @State private var isHardMode = false
    @State private var isQuizActive: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {

                Text("Quiz Settings")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)

                CategoryPicker(selectedCategory: $selectedCategory, categories: categories)

                Stepper("Questions: \(questionCount)", value: $questionCount, in: 5...20)

                HardModeToggle(isHardMode: $isHardMode)

                Spacer()

                StartButton{
                    isQuizActive = true
                }
                .navigationDestination(isPresented: $isQuizActive) {
                    QuizStartView(category: selectedCategory, questionCount: questionCount, isHardMode: isHardMode)
                }
            }
            .padding()
        }
    }
}

#Preview {
    QuizSettingsView()
}
