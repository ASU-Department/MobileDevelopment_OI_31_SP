//
//  PersistenceActorTests.swift
//  QuizWhizTests
//
//  Created for Lab 5 - Testing Actor Behavior
//

import XCTest
import SwiftData
@testable import QuizWhiz

final class PersistenceActorTests: XCTestCase {
    var modelContainer: ModelContainer!
    var persistenceActor: PersistenceActor!
    
    override func setUp() async throws {
        try await super.setUp()
        
        let schema = Schema([PersistedQuestion.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        persistenceActor = PersistenceActor(modelContainer: modelContainer)
    }
    
    override func tearDown() async throws {
        persistenceActor = nil
        modelContainer = nil
        try await super.tearDown()
    }
    
    // MARK: - Save Questions Tests
    
    func testSaveQuestions() async throws {
        // Given
        let questions = createTestQuestions(count: 3)
        
        // When
        try await persistenceActor.saveQuestions(questions)
        
        // Then
        let loaded = try await persistenceActor.loadQuestions()
        XCTAssertEqual(loaded.count, 3)
    }
    
    func testSaveQuestionsEmptyArray() async throws {
        // Given
        let questions: [Question] = []
        
        // When
        try await persistenceActor.saveQuestions(questions)
        
        // Then
        let loaded = try await persistenceActor.loadQuestions()
        XCTAssertEqual(loaded.count, 0)
    }
    
    func testSaveQuestionsUpdateExisting() async throws {
        // Given
        var question = createTestQuestion()
        question.userNote = "Original note"
        
        // Save initially
        try await persistenceActor.saveQuestions([question])
        
        // When - Update the question
        question.userNote = "Updated note"
        try await persistenceActor.updateQuestion(question)
        
        // Then
        let loaded = try await persistenceActor.loadQuestions()
        let loadedQuestion = loaded.first { $0.id == question.id }
        XCTAssertEqual(loadedQuestion?.userNote, "Updated note")
    }
    
    // MARK: - Load Questions Tests
    
    func testLoadQuestionsAll() async throws {
        // Given
        let questions = createTestQuestions(count: 5)
        try await persistenceActor.saveQuestions(questions)
        
        // When
        let loaded = try await persistenceActor.loadQuestions()
        
        // Then
        XCTAssertEqual(loaded.count, 5)
    }
    
    func testLoadQuestionsByCategory() async throws {
        // Given
        let scienceQuestions = (0..<3).map { index in
            Question(
                id: UUID(),
                category: "Science",
                type: "multiple",
                difficulty: "easy",
                question: "Science question \(index)?",
                correctAnswer: "Correct \(index)",
                incorrectAnswers: ["Wrong1", "Wrong2", "Wrong3"]
            )
        }
        
        let historyQuestions = (0..<2).map { index in
            Question(
                id: UUID(),
                category: "History",
                type: "multiple",
                difficulty: "easy",
                question: "History question \(index)?",
                correctAnswer: "Correct \(index)",
                incorrectAnswers: ["Wrong1", "Wrong2", "Wrong3"]
            )
        }
        
        try await persistenceActor.saveQuestions(scienceQuestions + historyQuestions)
        
        // When
        let loaded = try await persistenceActor.loadQuestions(category: "Science")
        
        // Then
        XCTAssertGreaterThanOrEqual(loaded.count, 3)
        XCTAssertTrue(loaded.allSatisfy { $0.category.contains("Science") })
    }
    
    func testLoadQuestionsEmpty() async throws {
        // When
        let loaded = try await persistenceActor.loadQuestions()
        
        // Then
        XCTAssertEqual(loaded.count, 0)
    }
    
    // MARK: - Update Question Tests
    
    func testUpdateQuestionFavorite() async throws {
        // Given
        var question = createTestQuestion()
        question.isFavorite = false
        try await persistenceActor.saveQuestions([question])
        
        // When
        question.isFavorite = true
        try await persistenceActor.updateQuestion(question)
        
        // Then
        let loaded = try await persistenceActor.loadQuestions()
        let loadedQuestion = loaded.first { $0.id == question.id }
        XCTAssertEqual(loadedQuestion?.isFavorite, true)
    }
    
    func testUpdateQuestionNote() async throws {
        // Given
        let question = createTestQuestion()
        try await persistenceActor.saveQuestions([question])
        
        // When
        var updatedQuestion = question
        updatedQuestion.userNote = "Test note"
        try await persistenceActor.updateQuestion(updatedQuestion)
        
        // Then
        let loaded = try await persistenceActor.loadQuestions()
        let loadedQuestion = loaded.first { $0.id == question.id }
        XCTAssertEqual(loadedQuestion?.userNote, "Test note")
    }
    
    func testUpdateQuestionNotExisting() async throws {
        // Given
        var question = createTestQuestion()
        question.userNote = "New note"
        
        // When - Update non-existing question (should create it)
        try await persistenceActor.updateQuestion(question)
        
        // Then
        let loaded = try await persistenceActor.loadQuestions()
        let loadedQuestion = loaded.first { $0.id == question.id }
        XCTAssertNotNil(loadedQuestion)
        XCTAssertEqual(loadedQuestion?.userNote, "New note")
    }
    
    // MARK: - Load Favorites Tests
    
    func testLoadFavorites() async throws {
        // Given
        var questions = createTestQuestions(count: 5)
        questions[0].isFavorite = true
        questions[2].isFavorite = true
        questions[4].isFavorite = true
        
        try await persistenceActor.saveQuestions(questions)
        
        // When
        let favorites = try await persistenceActor.loadFavorites()
        
        // Then
        XCTAssertGreaterThanOrEqual(favorites.count, 3)
        XCTAssertTrue(favorites.allSatisfy { $0.isFavorite == true })
    }
    
    func testLoadFavoritesEmpty() async throws {
        // Given
        let questions = createTestQuestions(count: 3)
        // All questions are not favorites
        try await persistenceActor.saveQuestions(questions)
        
        // When
        let favorites = try await persistenceActor.loadFavorites()
        
        // Then
        XCTAssertEqual(favorites.count, 0)
    }
    
    func testLoadFavoritesWithUserPreferences() async throws {
        // Given
        let questions = createTestQuestions(count: 3)
        try await persistenceActor.saveQuestions(questions)
        
        // Set favorite in UserPreferences
        UserPreferences.addFavorite(questions[0].id)
        
        // When
        let favorites = try await persistenceActor.loadFavorites()
        
        // Then
        XCTAssertGreaterThanOrEqual(favorites.count, 1)
        XCTAssertTrue(favorites.contains { $0.id == questions[0].id })
    }
    
    // MARK: - Merge With Saved State Tests
    
    func testMergeWithSavedState() async throws {
        // Given
        var savedQuestion = createTestQuestion()
        savedQuestion.isFavorite = true
        savedQuestion.userNote = "Saved note"
        try await persistenceActor.saveQuestions([savedQuestion])
        
        // Create a new question with same ID but different state
        var remoteQuestion = savedQuestion
        remoteQuestion.isFavorite = false
        remoteQuestion.userNote = nil
        
        // When
        let merged = try await persistenceActor.mergeWithSavedState([remoteQuestion])
        
        // Then
        XCTAssertEqual(merged.count, 1)
        XCTAssertEqual(merged.first?.isFavorite, true) // Preserved from saved state
        XCTAssertEqual(merged.first?.userNote, "Saved note") // Preserved from saved state
    }
    
    func testMergeWithSavedStateNewQuestion() async throws {
        // Given
        let newQuestion = createTestQuestion()
        
        // When
        let merged = try await persistenceActor.mergeWithSavedState([newQuestion])
        
        // Then
        XCTAssertEqual(merged.count, 1)
        XCTAssertEqual(merged.first?.id, newQuestion.id)
        XCTAssertEqual(merged.first?.isFavorite, false)
        XCTAssertNil(merged.first?.userNote)
    }
    
    func testMergeWithSavedStateMultipleQuestions() async throws {
        // Given
        var savedQuestions = createTestQuestions(count: 3)
        savedQuestions[0].isFavorite = true
        savedQuestions[1].userNote = "Note 1"
        try await persistenceActor.saveQuestions(savedQuestions)
        
        // Create remote questions (some new, some existing)
        var remoteQuestions = savedQuestions
        remoteQuestions[0].isFavorite = false // Should be preserved as true
        remoteQuestions[1].userNote = nil // Should be preserved as "Note 1"
        
        let newQuestion = createTestQuestion()
        remoteQuestions.append(newQuestion)
        
        // When
        let merged = try await persistenceActor.mergeWithSavedState(remoteQuestions)
        
        // Then
        XCTAssertEqual(merged.count, 4)
        let merged0 = merged.first { $0.id == savedQuestions[0].id }
        XCTAssertEqual(merged0?.isFavorite, true)
        let merged1 = merged.first { $0.id == savedQuestions[1].id }
        XCTAssertEqual(merged1?.userNote, "Note 1")
    }
    
    // MARK: - Concurrent Access Tests
    
    func testConcurrentSaveOperations() async throws {
        // Given
        let questions1 = createTestQuestions(count: 3)
        let questions2 = createTestQuestions(count: 3)
        
        // When - Save concurrently
        async let save1 = persistenceActor.saveQuestions(questions1)
        async let save2 = persistenceActor.saveQuestions(questions2)
        
        try await save1
        try await save2
        
        // Then
        let loaded = try await persistenceActor.loadQuestions()
        XCTAssertEqual(loaded.count, 6)
    }
    
    func testConcurrentReadWrite() async throws {
        // Given
        let questions = createTestQuestions(count: 5)
        try await persistenceActor.saveQuestions(questions)
        
        // When - Read and write concurrently
        async let read = persistenceActor.loadQuestions()
        async let update = {
            var question = questions[0]
            question.userNote = "Concurrent update"
            try await persistenceActor.updateQuestion(question)
        }()
        
        let loaded = try await read
        try await update
        
        // Then
        XCTAssertEqual(loaded.count, 5)
        let updated = try await persistenceActor.loadQuestions()
        let updatedQuestion = updated.first { $0.id == questions[0].id }
        XCTAssertEqual(updatedQuestion?.userNote, "Concurrent update")
    }
    
    func testConcurrentUpdates() async throws {
        // Given
        var question = createTestQuestion()
        try await persistenceActor.saveQuestions([question])
        
        // When - Update concurrently
        async let update1 = {
            var q = question
            q.userNote = "Update 1"
            try await persistenceActor.updateQuestion(q)
        }()
        
        async let update2 = {
            var q = question
            q.userNote = "Update 2"
            try await persistenceActor.updateQuestion(q)
        }()
        
        try await update1
        try await update2
        
        // Then - Last write should win
        let loaded = try await persistenceActor.loadQuestions()
        let loadedQuestion = loaded.first { $0.id == question.id }
        XCTAssertNotNil(loadedQuestion?.userNote)
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
                id: UUID(),
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

