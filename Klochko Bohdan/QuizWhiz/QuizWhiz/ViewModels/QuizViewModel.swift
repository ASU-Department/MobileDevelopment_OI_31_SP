//
//  QuizViewModel.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class QuizViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var offlineQuestions: [Question] = []
    
    private let category: String
    private let questionCount: Int
    private let isHardMode: Bool
    private let repository: QuestionRepositoryProtocol
    
    init(
        category: String,
        questionCount: Int,
        isHardMode: Bool,
        repository: QuestionRepositoryProtocol
    ) {
        self.category = category
        self.questionCount = questionCount
        self.isHardMode = isHardMode
        self.repository = repository
    }
    
    func loadQuestions() async {
        isLoading = true
        error = nil
        
        // Load offline questions first
        do {
            offlineQuestions = try await repository.loadQuestions(category: category)
        } catch {
            offlineQuestions = []
        }
        
        do {
            let difficulty = isHardMode ? "hard" : nil
            let fetchedQuestions = try await repository.fetchQuestions(
                category: category,
                difficulty: difficulty,
                amount: questionCount
            )
            
            // Save questions to persistence
            try await repository.saveQuestions(fetchedQuestions)
            
            // Merge with saved state (favorites, notes)
            let questionsWithSavedState = try await repository.mergeWithSavedState(fetchedQuestions)
            
            questions = questionsWithSavedState
            isLoading = false
            
            UserPreferences.lastUpdateTimestamp = Date()
            
        } catch {
            self.error = error
            isLoading = false
            
            if !offlineQuestions.isEmpty {
                questions = offlineQuestions
            }
        }
    }
    
    func refresh() async {
        await loadQuestions()
    }
    
    func useOfflineQuestions() {
        questions = offlineQuestions
        error = nil
    }
    
    func toggleFavorite(_ question: Question) async {
        var updatedQuestion = question
        updatedQuestion.isFavorite.toggle()
        
        if let index = questions.firstIndex(where: { $0.id == question.id }) {
            questions[index] = updatedQuestion
        }
        
        if updatedQuestion.isFavorite {
            UserPreferences.addFavorite(question.id)
        } else {
            UserPreferences.removeFavorite(question.id)
        }
        
        do {
            try await repository.updateQuestion(updatedQuestion)
        } catch {
            // Revert on error
            if let index = questions.firstIndex(where: { $0.id == question.id }) {
                questions[index] = question
            }
            self.error = error
        }
    }
    
    func updateQuestion(_ question: Question) async {
        if let index = questions.firstIndex(where: { $0.id == question.id }) {
            questions[index] = question
        }
        
        do {
            try await repository.updateQuestion(question)
        } catch {
            self.error = error
        }
    }
}

