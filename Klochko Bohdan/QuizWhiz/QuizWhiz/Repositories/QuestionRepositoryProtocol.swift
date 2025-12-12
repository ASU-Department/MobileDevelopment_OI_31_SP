//
//  QuestionRepositoryProtocol.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation

/// Protocol defining the interface for question data access
protocol QuestionRepositoryProtocol {
    /// Fetches questions from remote API
    func fetchQuestions(
        category: String?,
        difficulty: String?,
        amount: Int
    ) async throws -> [Question]
    
    /// Loads questions from local persistence
    func loadQuestions(category: String?) async throws -> [Question]
    
    /// Saves questions to local persistence
    func saveQuestions(_ questions: [Question]) async throws
    
    /// Updates a single question in local persistence
    func updateQuestion(_ question: Question) async throws
    
    /// Loads favorite questions from local persistence
    func loadFavorites() async throws -> [Question]
    
    /// Merges remote questions with saved state (favorites, notes)
    func mergeWithSavedState(_ questions: [Question]) async throws -> [Question]
}


