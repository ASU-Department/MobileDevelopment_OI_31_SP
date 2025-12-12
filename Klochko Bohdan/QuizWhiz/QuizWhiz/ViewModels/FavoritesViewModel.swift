//
//  FavoritesViewModel.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteQuestions: [Question] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let repository: QuestionRepositoryProtocol
    
    init(repository: QuestionRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadFavorites() async {
        isLoading = true
        error = nil
        await Task.yield()
        
        do {
            let questions = try await repository.loadFavorites()
            self.favoriteQuestions = questions
            self.isLoading = false
        } catch {
            self.error = error
            self.isLoading = false
        }
    }
    
    func toggleFavorite(_ question: Question) async {
        var updatedQuestion = question
        updatedQuestion.isFavorite = false
        
        if let index = favoriteQuestions.firstIndex(where: { $0.id == question.id }) {
            favoriteQuestions.remove(at: index)
        }
        
        UserPreferences.removeFavorite(question.id)
        
        do {
            try await repository.updateQuestion(updatedQuestion)
            await loadFavorites()
        } catch {
            self.error = error
            // Reload to restore state
            await loadFavorites()
        }
    }
    
    func updateQuestion(_ question: Question) async {
        if let index = favoriteQuestions.firstIndex(where: { $0.id == question.id }) {
            favoriteQuestions[index] = question
        }
        
        do {
            try await repository.updateQuestion(question)
        } catch {
            self.error = error
        }
    }
}

