//
//  FavoritesViewModel.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteQuestions: [Question] = []
    @Published var isLoading = false
    
    private let persistenceManager = PersistenceManager.shared
    
    func loadFavorites(modelContext: ModelContext) async {
        isLoading = true
        await Task.yield()
        
        let questions = persistenceManager.loadFavorites(from: modelContext)
        self.favoriteQuestions = questions
        self.isLoading = false
    }
    
    func toggleFavorite(_ question: Question, in modelContext: ModelContext) {
        var updatedQuestion = question
        updatedQuestion.isFavorite = false
        
        if let index = favoriteQuestions.firstIndex(where: { $0.id == question.id }) {
            favoriteQuestions.remove(at: index)
        }
        
        persistenceManager.updateQuestion(updatedQuestion, in: modelContext)
        
        Task {
            await loadFavorites(modelContext: modelContext)
        }
    }
    
    func updateQuestion(_ question: Question, in modelContext: ModelContext) {
        if let index = favoriteQuestions.firstIndex(where: { $0.id == question.id }) {
            favoriteQuestions[index] = question
        }
        
        persistenceManager.updateQuestion(question, in: modelContext)
    }
}

