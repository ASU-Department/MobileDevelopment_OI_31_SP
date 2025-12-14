//
//  QuizViewModel.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftData
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
    private let quizService = QuizService.shared
    private let persistenceManager = PersistenceManager.shared
    
    init(category: String, questionCount: Int, isHardMode: Bool) {
        self.category = category
        self.questionCount = questionCount
        self.isHardMode = isHardMode
    }
    
    func loadQuestions(modelContext: ModelContext) async {
        isLoading = true
        error = nil
        
        offlineQuestions = persistenceManager.loadQuestions(from: modelContext, category: category)
        
        do {
            let difficulty = isHardMode ? "hard" : nil
            let fetchedQuestions = try await quizService.fetchQuestions(
                category: category,
                difficulty: difficulty,
                amount: questionCount
            )
            
            persistenceManager.saveQuestions(fetchedQuestions, to: modelContext)
            
            let questionsWithSavedState = persistenceManager.mergeWithSavedState(
                fetchedQuestions,
                from: modelContext
            )
            
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
    
    func refresh(modelContext: ModelContext) async {
        await loadQuestions(modelContext: modelContext)
    }
    
    func useOfflineQuestions() {
        questions = offlineQuestions
        error = nil
    }
    
    func toggleFavorite(_ question: Question, in modelContext: ModelContext) {
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
        
        let descriptor = FetchDescriptor<PersistedQuestion>(
            predicate: #Predicate { $0.id == question.id }
        )
        
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.isFavorite = updatedQuestion.isFavorite
        } else {
            let persisted = PersistedQuestion(from: updatedQuestion)
            modelContext.insert(persisted)
        }
        
        do {
            try modelContext.save()
        } catch {
        }
    }
    
    func updateQuestion(_ question: Question, in modelContext: ModelContext) {
        if let index = questions.firstIndex(where: { $0.id == question.id }) {
            questions[index] = question
        }
        
        persistenceManager.updateQuestion(question, in: modelContext)
    }
}

