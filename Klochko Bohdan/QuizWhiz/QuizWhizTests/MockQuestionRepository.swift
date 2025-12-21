//
//  MockQuestionRepository.swift
//  QuizWhizTests
//
//  Created for testing purposes
//

import Foundation
@testable import QuizWhiz

/// Mock repository for testing ViewModels
class MockQuestionRepository: QuestionRepositoryProtocol {
    var fetchQuestionsResult: Result<[Question], Error> = .success([])
    var loadQuestionsResult: Result<[Question], Error> = .success([])
    var saveQuestionsError: Error?
    var updateQuestionError: Error?
    var loadFavoritesResult: Result<[Question], Error> = .success([])
    var mergeWithSavedStateResult: Result<[Question], Error> = .success([])
    
    var fetchQuestionsCallCount = 0
    var loadQuestionsCallCount = 0
    var saveQuestionsCallCount = 0
    var updateQuestionCallCount = 0
    var loadFavoritesCallCount = 0
    var mergeWithSavedStateCallCount = 0
    
    var lastFetchCategory: String?
    var lastFetchDifficulty: String?
    var lastFetchAmount: Int?
    var lastLoadCategory: String?
    var lastUpdateQuestion: Question?
    var lastSavedQuestions: [Question]?
    
    func fetchQuestions(
        category: String?,
        difficulty: String?,
        amount: Int
    ) async throws -> [Question] {
        fetchQuestionsCallCount += 1
        lastFetchCategory = category
        lastFetchDifficulty = difficulty
        lastFetchAmount = amount
        
        switch fetchQuestionsResult {
        case .success(let questions):
            return questions
        case .failure(let error):
            throw error
        }
    }
    
    func loadQuestions(category: String?) async throws -> [Question] {
        loadQuestionsCallCount += 1
        lastLoadCategory = category
        
        switch loadQuestionsResult {
        case .success(let questions):
            return questions
        case .failure(let error):
            throw error
        }
    }
    
    func saveQuestions(_ questions: [Question]) async throws {
        saveQuestionsCallCount += 1
        lastSavedQuestions = questions
        
        if let error = saveQuestionsError {
            throw error
        }
    }
    
    func updateQuestion(_ question: Question) async throws {
        updateQuestionCallCount += 1
        lastUpdateQuestion = question
        
        if let error = updateQuestionError {
            throw error
        }
    }
    
    func loadFavorites() async throws -> [Question] {
        loadFavoritesCallCount += 1
        
        switch loadFavoritesResult {
        case .success(let questions):
            return questions
        case .failure(let error):
            throw error
        }
    }
    
    func mergeWithSavedState(_ questions: [Question]) async throws -> [Question] {
        mergeWithSavedStateCallCount += 1
        
        switch mergeWithSavedStateResult {
        case .success(let questions):
            return questions
        case .failure(let error):
            throw error
        }
    }
    
    func reset() {
        fetchQuestionsCallCount = 0
        loadQuestionsCallCount = 0
        saveQuestionsCallCount = 0
        updateQuestionCallCount = 0
        loadFavoritesCallCount = 0
        mergeWithSavedStateCallCount = 0
        lastFetchCategory = nil
        lastFetchDifficulty = nil
        lastFetchAmount = nil
        lastLoadCategory = nil
        lastUpdateQuestion = nil
        lastSavedQuestions = nil
    }
}

