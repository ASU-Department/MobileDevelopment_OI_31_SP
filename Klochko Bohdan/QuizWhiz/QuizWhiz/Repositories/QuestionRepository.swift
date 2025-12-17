//
//  QuestionRepository.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation

/// Repository implementation that coordinates between remote API and local persistence
class QuestionRepository: QuestionRepositoryProtocol {
    private let quizService: QuizService
    private let persistenceActor: PersistenceActor
    
    init(quizService: QuizService = .shared, persistenceActor: PersistenceActor) {
        self.quizService = quizService
        self.persistenceActor = persistenceActor
    }
    
    func fetchQuestions(
        category: String?,
        difficulty: String?,
        amount: Int
    ) async throws -> [Question] {
        return try await quizService.fetchQuestions(
            category: category,
            difficulty: difficulty,
            amount: amount
        )
    }
    
    func loadQuestions(category: String?) async throws -> [Question] {
        return try await persistenceActor.loadQuestions(category: category)
    }
    
    func saveQuestions(_ questions: [Question]) async throws {
        try await persistenceActor.saveQuestions(questions)
    }
    
    func updateQuestion(_ question: Question) async throws {
        try await persistenceActor.updateQuestion(question)
    }
    
    func loadFavorites() async throws -> [Question] {
        return try await persistenceActor.loadFavorites()
    }
    
    func mergeWithSavedState(_ questions: [Question]) async throws -> [Question] {
        return try await persistenceActor.mergeWithSavedState(questions)
    }
}



