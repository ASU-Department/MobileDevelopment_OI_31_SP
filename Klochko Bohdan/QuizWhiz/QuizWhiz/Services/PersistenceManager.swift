//
//  PersistenceManager.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftData

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private init() {}
    
    func saveQuestions(_ questions: [Question], to modelContext: ModelContext) {
        modelContext.processPendingChanges()
        
        for question in questions {
            let descriptor = FetchDescriptor<PersistedQuestion>(
                predicate: #Predicate { $0.id == question.id }
            )
            
            if let existing = try? modelContext.fetch(descriptor).first {
                existing.category = question.category
                existing.type = question.type
                existing.difficulty = question.difficulty
                existing.question = question.question
                existing.correctAnswer = question.correctAnswer
                existing.incorrectAnswers = question.incorrectAnswers
            } else {
                let persisted = PersistedQuestion(from: question)
                modelContext.insert(persisted)
            }
        }
        
        modelContext.processPendingChanges()
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save questions: \(error)")
        }
    }
    
    func loadQuestions(from modelContext: ModelContext, category: String? = nil) -> [Question] {
        var descriptor: FetchDescriptor<PersistedQuestion>
        
        if let category = category {
            descriptor = FetchDescriptor<PersistedQuestion>(
                predicate: #Predicate { $0.category.contains(category) }
            )
        } else {
            descriptor = FetchDescriptor<PersistedQuestion>()
        }
        
        descriptor.sortBy = [SortDescriptor(\.createdAt, order: .reverse)]
        
        do {
            let persisted = try modelContext.fetch(descriptor)
            return persisted.map { $0.toQuestion() }
        } catch {
            return []
        }
    }
    
    func updateQuestion(_ question: Question, in modelContext: ModelContext) {
        let descriptor = FetchDescriptor<PersistedQuestion>(
            predicate: #Predicate { $0.id == question.id }
        )
        
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.isFavorite = question.isFavorite
            existing.userNote = question.userNote
        } else {
            let persisted = PersistedQuestion(from: question)
            modelContext.insert(persisted)
        }
        
        do {
            try modelContext.save()
        } catch {
        }
    }
    
    func mergeWithSavedState(_ questions: [Question], from modelContext: ModelContext) -> [Question] {
        return questions.map { question in
            let descriptor = FetchDescriptor<PersistedQuestion>(
                predicate: #Predicate { $0.id == question.id }
            )
            
            if let saved = try? modelContext.fetch(descriptor).first {
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
    
    func loadFavorites(from modelContext: ModelContext) -> [Question] {
        do {
            let favoriteIds = Set(UserPreferences.favoriteQuestionIds)
            
            if favoriteIds.isEmpty {
                let allQuestions = try modelContext.fetch(FetchDescriptor<PersistedQuestion>())
                let favorites = allQuestions.filter { $0.isFavorite == true }
                    .sorted { $0.createdAt > $1.createdAt }
                    .prefix(500)
                return Array(favorites.map { $0.toQuestion() })
            } else {
                let allQuestions = try modelContext.fetch(FetchDescriptor<PersistedQuestion>())
                let favorites = allQuestions.filter { question in
                    favoriteIds.contains(question.id.uuidString) || question.isFavorite == true
                }
                .sorted { $0.createdAt > $1.createdAt }
                .prefix(500)
                return Array(favorites.map { $0.toQuestion() })
            }
        } catch {
            return []
        }
    }
}

