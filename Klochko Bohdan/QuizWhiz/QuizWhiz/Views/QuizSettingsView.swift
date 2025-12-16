//
//  QuizSettingsView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI
import SwiftData

struct QuizSettingsView: View {
    @StateObject private var viewModel: QuizSettingsViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: QuizSettingsViewModel())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quiz Settings")
                        .font(.largeTitle.bold())
                    
                    Text(viewModel.lastUpdateText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 10)

                // Category Selection
                CategoryPicker(selectedCategory: $viewModel.selectedCategory, categories: categories)

                // Question Count
                VStack(alignment: .leading, spacing: 8) {
                    Text("Number of Questions")
                        .font(.headline)
                    Stepper("Questions: \(viewModel.questionCount)", value: $viewModel.questionCount, in: 5...20)
                        .onChange(of: viewModel.questionCount) { _, newValue in
                            viewModel.updateQuestionCount(newValue)
                        }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                // Hard Mode Toggle
                HardModeToggle(isHardMode: $viewModel.isHardMode)

                // Additional Options
                VStack(alignment: .leading, spacing: 12) {
                    Text("Options")
                        .font(.headline)
                    
                    Button(action: {
                        coordinator.navigateToFavorites()
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
                    coordinator.navigateToQuiz(
                        category: viewModel.selectedCategory,
                        questionCount: viewModel.questionCount,
                        isHardMode: viewModel.isHardMode
                    )
                }
            }
            .padding()
        }
        .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .quiz(let category, let questionCount, let isHardMode):
                QuizStartView(
                    category: category,
                    questionCount: questionCount,
                    isHardMode: isHardMode,
                    coordinator: coordinator
                )
            case .favorites:
                FavoritesView(coordinator: coordinator)
            }
        }
    }
}

#Preview {
    let container: ModelContainer = {
        let schema = Schema([PersistedQuestion.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    let coordinator = AppCoordinator(modelContainer: container)
    return QuizSettingsView(coordinator: coordinator)
        .environmentObject(coordinator)
}
