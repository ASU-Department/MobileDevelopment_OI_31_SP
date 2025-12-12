//
//  AppCoordinator.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI
import SwiftData
import Combine

/// Coordinator responsible for app composition, dependency injection, and navigation
@MainActor
class AppCoordinator: ObservableObject {
    let persistenceActor: PersistenceActor
    let questionRepository: QuestionRepositoryProtocol
    
    @Published var navigationPath = NavigationPath()
    
    init(modelContainer: ModelContainer) {
        self.persistenceActor = PersistenceActor(modelContainer: modelContainer)
        self.questionRepository = QuestionRepository(persistenceActor: persistenceActor)
    }
    
    /// Creates the root view with injected dependencies
    func makeRootView() -> some View {
        QuizSettingsView(coordinator: self)
    }
    
    /// Navigates to quiz start view
    func navigateToQuiz(category: Category, questionCount: Int, isHardMode: Bool) {
        navigationPath.append(NavigationDestination.quiz(category: category, questionCount: questionCount, isHardMode: isHardMode))
    }
    
    /// Navigates to favorites view
    func navigateToFavorites() {
        navigationPath.append(NavigationDestination.favorites)
    }
    
    /// Navigates back
    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
}

/// Navigation destinations enum
enum NavigationDestination: Hashable {
    case quiz(category: Category, questionCount: Int, isHardMode: Bool)
    case favorites
}


