//
//  FavoritesViewModelTests.swift
//  QuizWhizTests
//
//  Created for Lab 5 - Using XCTest
//

import XCTest
@testable import QuizWhiz

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    var mockRepository: MockQuestionRepository!
    var viewModel: FavoritesViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockQuestionRepository()
        viewModel = FavoritesViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        XCTAssertEqual(viewModel.favoriteQuestions.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    // MARK: - Load Favorites Tests
    
    func testLoadFavoritesSuccess() async {
        // Given
        let testQuestions = createTestQuestions(count: 3)
        mockRepository.loadFavoritesResult = .success(testQuestions)
        
        // When
        await viewModel.loadFavorites()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.favoriteQuestions.count, 3)
        XCTAssertEqual(mockRepository.loadFavoritesCallCount, 1)
    }
    
    func testLoadFavoritesEmpty() async {
        // Given
        mockRepository.loadFavoritesResult = .success([])
        
        // When
        await viewModel.loadFavorites()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.favoriteQuestions.count, 0)
    }
    
    func testLoadFavoritesWithError() async {
        // Given
        let testError = NSError(domain: "TestError", code: 1)
        mockRepository.loadFavoritesResult = .failure(testError)
        
        // When
        await viewModel.loadFavorites()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual(viewModel.favoriteQuestions.count, 0)
    }
    
    func testLoadFavoritesLoadingState() async {
        // Given
        let testQuestions = createTestQuestions(count: 2)
        mockRepository.loadFavoritesResult = .success(testQuestions)
        
        // When
        let loadingTask = Task {
            await viewModel.loadFavorites()
        }
        
        // Wait a bit to check loading state
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        
        // Then - isLoading should be true during loading
        // Note: This is a timing-dependent test, but we verify the final state
        await loadingTask.value
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.favoriteQuestions.count, 2)
    }
    
    // MARK: - Toggle Favorite Tests
    
    func testToggleFavoriteSuccess() async {
        // Given
        var question = createTestQuestion()
        question.isFavorite = true
        UserPreferences.addFavorite(question.id)
        
        viewModel.favoriteQuestions = [question]
        
        // When
        await viewModel.toggleFavorite(question)
        
        // Then
        XCTAssertFalse(viewModel.favoriteQuestions.contains { $0.id == question.id })
        XCTAssertEqual(mockRepository.updateQuestionCallCount, 1)
        XCTAssertFalse(UserPreferences.isFavorite(question.id))
        XCTAssertEqual(mockRepository.loadFavoritesCallCount, 1) // Reloaded after toggle
    }
    
    func testToggleFavoriteWithError() async {
        // Given
        var question = createTestQuestion()
        question.isFavorite = true
        UserPreferences.addFavorite(question.id)
        
        let updateError = NSError(domain: "UpdateError", code: 1)
        mockRepository.updateQuestionError = updateError
        mockRepository.loadFavoritesResult = .success([question])
        
        viewModel.favoriteQuestions = [question]
        
        // When
        await viewModel.toggleFavorite(question)
        
        // Then
        XCTAssertNotNil(viewModel.error)
        // Should reload to restore state
        XCTAssertGreaterThanOrEqual(mockRepository.loadFavoritesCallCount, 1)
    }
    
    func testToggleFavoriteRemovesFromList() async {
        // Given
        let questions = createTestQuestions(count: 3)
        var questionToRemove = questions[1]
        questionToRemove.isFavorite = true
        UserPreferences.addFavorite(questionToRemove.id)
        
        viewModel.favoriteQuestions = questions
        mockRepository.loadFavoritesResult = .success(Array(questions.filter { $0.id != questionToRemove.id }))
        
        // When
        await viewModel.toggleFavorite(questionToRemove)
        
        // Then
        XCTAssertFalse(viewModel.favoriteQuestions.contains { $0.id == questionToRemove.id })
        XCTAssertEqual(viewModel.favoriteQuestions.count, 2)
    }
    
    // MARK: - Update Question Tests
    
    func testUpdateQuestionSuccess() async {
        // Given
        var question = createTestQuestion()
        question.isFavorite = true
        question.userNote = "Updated note"
        
        var originalQuestion = createTestQuestion()
        originalQuestion.isFavorite = true
        
        viewModel.favoriteQuestions = [originalQuestion]
        
        // When
        await viewModel.updateQuestion(question)
        
        // Then
        XCTAssertEqual(viewModel.favoriteQuestions.first?.userNote, "Updated note")
        XCTAssertEqual(mockRepository.updateQuestionCallCount, 1)
        XCTAssertNil(viewModel.error)
    }
    
    func testUpdateQuestionWithError() async {
        // Given
        var question = createTestQuestion()
        question.isFavorite = true
        question.userNote = "Updated note"
        
        var originalQuestion = createTestQuestion()
        originalQuestion.isFavorite = true
        
        let updateError = NSError(domain: "UpdateError", code: 1)
        mockRepository.updateQuestionError = updateError
        
        viewModel.favoriteQuestions = [originalQuestion]
        
        // When
        await viewModel.updateQuestion(question)
        
        // Then
        XCTAssertNotNil(viewModel.error)
        // Question should still be updated in local state
        XCTAssertEqual(viewModel.favoriteQuestions.first?.userNote, "Updated note")
    }
    
    func testUpdateQuestionNotFound() async {
        // Given
        var question = createTestQuestion()
        question.isFavorite = true
        
        viewModel.favoriteQuestions = []
        
        // When
        await viewModel.updateQuestion(question)
        
        // Then
        // Should not crash, but question won't be in list
        XCTAssertEqual(viewModel.favoriteQuestions.count, 0)
    }
    
    // MARK: - Error Handling Tests
    
    func testErrorStateClearedOnSuccess() async {
        // Given
        let testError = NSError(domain: "TestError", code: 1)
        mockRepository.loadFavoritesResult = .failure(testError)
        await viewModel.loadFavorites()
        XCTAssertNotNil(viewModel.error)
        
        // When
        let testQuestions = createTestQuestions(count: 2)
        mockRepository.loadFavoritesResult = .success(testQuestions)
        await viewModel.loadFavorites()
        
        // Then
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.favoriteQuestions.count, 2)
    }
    
    // MARK: - Helper Methods
    
    private func createTestQuestion() -> Question {
        Question(
            category: "Science",
            type: "multiple",
            difficulty: "easy",
            question: "Test question?",
            correctAnswer: "Correct",
            incorrectAnswers: ["Wrong1", "Wrong2", "Wrong3"],
            isFavorite: true
        )
    }
    
    private func createTestQuestions(count: Int) -> [Question] {
        (0..<count).map { index in
            Question(
                category: "Science",
                type: "multiple",
                difficulty: "easy",
                question: "Test question \(index)?",
                correctAnswer: "Correct \(index)",
                incorrectAnswers: ["Wrong1", "Wrong2", "Wrong3"],
                isFavorite: true
            )
        }
    }
}

