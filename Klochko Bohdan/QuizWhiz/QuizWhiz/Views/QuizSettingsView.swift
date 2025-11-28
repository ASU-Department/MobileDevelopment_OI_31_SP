//
//  QuizSettingsView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI
import SwiftData

struct QuizSettingsView: View {
    @State private var questionCount = UserPreferences.questionsPerPage
    @State private var selectedCategory: Category = categories.first!
    @State private var isHardMode = false
    @State private var isQuizActive: Bool = false
    @State private var showFavorites = false
    @Environment(\.modelContext) private var modelContext
    
    private var lastUpdateText: String {
        if let timestamp = UserPreferences.lastUpdateTimestamp {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return "Last updated: \(formatter.localizedString(for: timestamp, relativeTo: Date()))"
        }
        return "No updates yet"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quiz Settings")
                            .font(.largeTitle.bold())
                        
                        Text(lastUpdateText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)

                    // Category Selection
                    CategoryPicker(selectedCategory: $selectedCategory, categories: categories)

                    // Question Count
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Number of Questions")
                            .font(.headline)
                        Stepper("Questions: \(questionCount)", value: $questionCount, in: 5...20)
                            .onChange(of: questionCount) { _, newValue in
                                UserPreferences.questionsPerPage = newValue
                            }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    // Hard Mode Toggle
                    HardModeToggle(isHardMode: $isHardMode)

                    // Additional Options
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Options")
                            .font(.headline)
                        
                        Button(action: {
                            showFavorites = true
                        }) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                Text("View Favorites")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    Spacer()

                    // Start Button
                    StartButton {
                        isQuizActive = true
                    }
                    .navigationDestination(isPresented: $isQuizActive) {
                        QuizStartView(
                            category: selectedCategory,
                            questionCount: questionCount,
                            isHardMode: isHardMode
                        )
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $showFavorites) {
                FavoritesView()
            }
        }
    }
}

#Preview {
    QuizSettingsView()
}
