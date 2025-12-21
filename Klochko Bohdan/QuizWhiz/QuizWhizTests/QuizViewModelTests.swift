//
//  QuizViewModelTests.swift
//  QuizWhizTests
//
//  Created for Lab 5
//

import XCTest
@testable import QuizWhiz

@MainActor
final class QuizViewModelTests: XCTestCase {
    var mockRepository: MockQuestionRepository!
    var viewModel: QuizViewModel!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockQuestionRepository()
    }
    
    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: true,
            repository: mockRepository
        )
        
        XCTAssertEqual(viewModel.questions.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.offlineQuestions.count, 0)
    }
    
    // MARK: - Load Questions Tests
    
    func testLoadQuestionsSuccess() async {
        // Given
        let testQuestions = createTestQuestions(count: 5)
        mockRepository.fetchQuestionsResult = .success(testQuestions)
        mockRepository.loadQuestionsResult = .success([])
        mockRepository.mergeWithSavedStateResult = .success(testQuestions)
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 5,
            isHardMode: false,
            repository: mockRepository
        )
        
        // When
        await viewModel.loadQuestions()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.questions.count, 5)
        XCTAssertEqual(mockRepository.fetchQuestionsCallCount, 1)
        XCTAssertEqual(mockRepository.lastFetchCategory, "Science")
        XCTAssertNil(mockRepository.lastFetchDifficulty)
        XCTAssertEqual(mockRepository.lastFetchAmount, 5)
        XCTAssertEqual(mockRepository.saveQuestionsCallCount, 1)
        XCTAssertEqual(mockRepository.mergeWithSavedStateCallCount, 1)
    }
    
    func testLoadQuestionsWithHardMode() async {
        // Given
        let testQuestions = createTestQuestions(count: 3)
        mockRepository.fetchQuestionsResult = .success(testQuestions)
        mockRepository.loadQuestionsResult = .success([])
        mockRepository.mergeWithSavedStateResult = .success(testQuestions)
        
        viewModel = QuizViewModel(
            category: "History",
            questionCount: 3,
            isHardMode: true,
            repository: mockRepository
        )
        
        // When
        await viewModel.loadQuestions()
        
        // Then
        XCTAssertEqual(mockRepository.lastFetchDifficulty, "hard")
        XCTAssertEqual(mockRepository.lastFetchCategory, "History")
    }
    
    func testLoadQuestionsWithError() async {
        // Given
        let testError = NSError(domain: "TestError", code: 1)
        mockRepository.fetchQuestionsResult = .failure(testError)
        mockRepository.loadQuestionsResult = .success([])
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        
        // When
        await viewModel.loadQuestions()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual(viewModel.questions.count, 0)
    }
    
    func testLoadQuestionsWithErrorAndOfflineFallback() async {
        // Given
        let offlineQuestions = createTestQuestions(count: 3)
        let testError = NSError(domain: "TestError", code: 1)
        mockRepository.fetchQuestionsResult = .failure(testError)
        mockRepository.loadQuestionsResult = .success(offlineQuestions)
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        
        // When
        await viewModel.loadQuestions()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual(viewModel.questions.count, 3)
        XCTAssertEqual(viewModel.offlineQuestions.count, 3)
    }
    
    func testLoadQuestionsWithOfflineLoadError() async {
        // Given
        let offlineError = NSError(domain: "OfflineError", code: 2)
        let fetchError = NSError(domain: "FetchError", code: 1)
        mockRepository.fetchQuestionsResult = .failure(fetchError)
        mockRepository.loadQuestionsResult = .failure(offlineError)
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        
        // When
        await viewModel.loadQuestions()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual(viewModel.questions.count, 0)
        XCTAssertEqual(viewModel.offlineQuestions.count, 0)
    }
    
    // MARK: - Refresh Tests
    
    func testRefresh() async {
        // Given
        let testQuestions = createTestQuestions(count: 5)
        mockRepository.fetchQuestionsResult = .success(testQuestions)
        mockRepository.loadQuestionsResult = .success([])
        mockRepository.mergeWithSavedStateResult = .success(testQuestions)
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 5,
            isHardMode: false,
            repository: mockRepository
        )
        
        // When
        await viewModel.refresh()
        
        // Then
        XCTAssertEqual(viewModel.questions.count, 5)
        XCTAssertEqual(mockRepository.fetchQuestionsCallCount, 1)
    }
    
    // MARK: - Use Offline Questions Tests
    
    func testUseOfflineQuestions() {
        // Given
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        
        let offlineQuestions = createTestQuestions(count: 3)
        viewModel.offlineQuestions = offlineQuestions
        viewModel.error = NSError(domain: "Test", code: 1)
        
        // When
        viewModel.useOfflineQuestions()
        
        // Then
        XCTAssertEqual(viewModel.questions.count, 3)
        XCTAssertNil(viewModel.error)
    }
    
    // MARK: - Toggle Favorite Tests
    
    func testToggleFavoriteSuccess() async {
        // Given
        var question = createTestQuestion()
        question.isFavorite = false
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        viewModel.questions = [question]
        
        // When
        await viewModel.toggleFavorite(question)
        
        // Then
        XCTAssertTrue(viewModel.questions.first?.isFavorite ?? false)
        XCTAssertEqual(mockRepository.updateQuestionCallCount, 1)
        XCTAssertTrue(UserPreferences.isFavorite(question.id))
    }
    
    func testToggleFavoriteUnfavorite() async {
        // Given
        var question = createTestQuestion()
        question.isFavorite = true
        UserPreferences.addFavorite(question.id)
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        viewModel.questions = [question]
        
        // When
        await viewModel.toggleFavorite(question)
        
        // Then
        XCTAssertFalse(viewModel.questions.first?.isFavorite ?? true)
        XCTAssertFalse(UserPreferences.isFavorite(question.id))
    }
    
    func testToggleFavoriteWithError() async {
        // Given
        var question = createTestQuestion()
        question.isFavorite = false
        let originalFavorite = question.isFavorite
        
        let updateError = NSError(domain: "UpdateError", code: 1)
        mockRepository.updateQuestionError = updateError
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        viewModel.questions = [question]
        
        // When
        await viewModel.toggleFavorite(question)
        
        // Then
        XCTAssertEqual(viewModel.questions.first?.isFavorite, originalFavorite)
        XCTAssertNotNil(viewModel.error)
    }
    
    // MARK: - Update Question Tests
    
    func testUpdateQuestionSuccess() async {
        // Given
        var question = createTestQuestion()
        question.userNote = "Test note"
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        viewModel.questions = [createTestQuestion()]
        
        // When
        await viewModel.updateQuestion(question)
        
        // Then
        XCTAssertEqual(viewModel.questions.first?.userNote, "Test note")
        XCTAssertEqual(mockRepository.updateQuestionCallCount, 1)
        XCTAssertNil(viewModel.error)
    }
    
    func testUpdateQuestionWithError() async {
        // Given
        var question = createTestQuestion()
        question.userNote = "Test note"
        
        let updateError = NSError(domain: "UpdateError", code: 1)
        mockRepository.updateQuestionError = updateError
        
        viewModel = QuizViewModel(
            category: "Science",
            questionCount: 10,
            isHardMode: false,
            repository: mockRepository
        )
        viewModel.questions = [createTestQuestion()]
        
        // When
        await viewModel.updateQuestion(question)
        
        // Then
        XCTAssertNotNil(viewModel.error)
    }
    
    // MARK: - Helper Methods
    
    private func createTestQuestion() -> Question {
        Question(
            category: "Science",
            type: "multiple",
            difficulty: "easy",
            question: "Test question?",
            correctAnswer: "Correct",
            incorrectAnswers: ["Wrong1", "Wrong2", "Wrong3"]
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
                incorrectAnswers: ["Wrong1", "Wrong2", "Wrong3"]
            )
        }
    }
}

