//
//  PersistenceActor.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftData

/// Actor responsible for thread-safe persistence operations
actor PersistenceActor {
    private let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    /// Creates a new model context for operations
    private func createContext() -> ModelContext {
        return ModelContext(modelContainer)
    }
    
    /// Saves questions to persistence
    func saveQuestions(_ questions: [Question]) throws {
        let context = createContext()
        context.processPendingChanges()
        
        for question in questions {
            let descriptor = FetchDescriptor<PersistedQuestion>(
                predicate: #Predicate { $0.id == question.id }
            )
            
            if let existing = try? context.fetch(descriptor).first {
                existing.category = question.category
                existing.type = question.type
                existing.difficulty = question.difficulty
                existing.question = question.question
                existing.correctAnswer = question.correctAnswer
                existing.incorrectAnswers = question.incorrectAnswers
            } else {
                let persisted = PersistedQuestion(from: question)
                context.insert(persisted)
            }
        }
        
        context.processPendingChanges()
        try context.save()
    }
    
    /// Loads questions from persistence
    func loadQuestions(category: String? = nil) throws -> [Question] {
        let context = createContext()
        var descriptor: FetchDescriptor<PersistedQuestion>
        
        if let category = category {
            descriptor = FetchDescriptor<PersistedQuestion>(
                predicate: #Predicate { $0.category.contains(category) }
            )
        } else {
            descriptor = FetchDescriptor<PersistedQuestion>()
        }
        
        descriptor.sortBy = [SortDescriptor(\.createdAt, order: .reverse)]
        
        let persisted = try context.fetch(descriptor)
        return persisted.map { $0.toQuestion() }
    }
    
    /// Updates a single question
    func updateQuestion(_ question: Question) throws {
        let context = createContext()
        let descriptor = FetchDescriptor<PersistedQuestion>(
            predicate: #Predicate { $0.id == question.id }
        )
        
        if let existing = try? context.fetch(descriptor).first {
            existing.isFavorite = question.isFavorite
            existing.userNote = question.userNote
        } else {
            let persisted = PersistedQuestion(from: question)
            context.insert(persisted)
        }
        
        try context.save()
    }
    
    /// Loads favorite questions
    func loadFavorites() throws -> [Question] {
        let context = createContext()
        let favoriteIds = Set(UserPreferences.favoriteQuestionIds)
        
        if favoriteIds.isEmpty {
            let allQuestions = try context.fetch(FetchDescriptor<PersistedQuestion>())
            let favorites = allQuestions.filter { $0.isFavorite == true }
                .sorted { $0.createdAt > $1.createdAt }
                .prefix(500)
            return Array(favorites.map { $0.toQuestion() })
        } else {
            let allQuestions = try context.fetch(FetchDescriptor<PersistedQuestion>())
            let favorites = allQuestions.filter { question in
                favoriteIds.contains(question.id.uuidString) || question.isFavorite == true
            }
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(500)
            return Array(favorites.map { $0.toQuestion() })
        }
    }
    
    /// Merges remote questions with saved state
    func mergeWithSavedState(_ questions: [Question]) throws -> [Question] {
        let context = createContext()
        return questions.map { question in
            let descriptor = FetchDescriptor<PersistedQuestion>(
                predicate: #Predicate { $0.id == question.id }
            )
            
            if let saved = try? context.fetch(descriptor).first {
                return Question(
                    id: question.id,
                    category: question.category,
                    type: question.type,
                    difficulty: question.difficulty,
                    question: question.question,
                    correctAnswer: question.correctAnswer,
                    incorrectAnswers: question.incorrectAnswers,
                    isFavorite: saved.isFavorite,
                    userNote: saved.userNote
                )
            } else {
                return question
            }
        }
    }
}



