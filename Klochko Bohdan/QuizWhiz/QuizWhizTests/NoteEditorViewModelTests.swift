//
//  NoteEditorViewModelTests.swift
//  QuizWhizTests
//
//  Created for Lab 5 - Using Swift Testing
//

import Foundation
import Testing
@testable import QuizWhiz

@MainActor
struct NoteEditorViewModelTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func testInitializationWithNote() async {
        // Given
        var question = createTestQuestion()
        question.userNote = "Existing note"
        let mockRepository = MockQuestionRepository()
        
        // When
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        
        // Then
        #expect(viewModel.noteText == "Existing note")
        #expect(viewModel.error == nil)
    }
    
    @Test
    func testInitializationWithoutNote() async {
        // Given
        let question = createTestQuestion()
        let mockRepository = MockQuestionRepository()
        
        // When
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        
        // Then
        #expect(viewModel.noteText == "")
        #expect(viewModel.error == nil)
    }
    
    @Test
    func testInitializationWithEmptyNote() async {
        // Given
        var question = createTestQuestion()
        question.userNote = ""
        let mockRepository = MockQuestionRepository()
        
        // When
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        
        // Then
        #expect(viewModel.noteText == "")
    }
    
    // MARK: - Save Tests
    
    @Test
    func testSaveWithNewNote() async throws {
        // Given
        let question = createTestQuestion()
        let mockRepository = MockQuestionRepository()
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        viewModel.noteText = "New note"
        
        // When
        let updatedQuestion = try await viewModel.save()
        
        // Then
        #expect(updatedQuestion.userNote == "New note")
        #expect(mockRepository.updateQuestionCallCount == 1)
        #expect(mockRepository.lastUpdateQuestion?.userNote == "New note")
    }
    
    @Test
    func testSaveWithEmptyNote() async throws {
        // Given
        var question = createTestQuestion()
        question.userNote = "Old note"
        let mockRepository = MockQuestionRepository()
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        viewModel.noteText = ""
        
        // When
        let updatedQuestion = try await viewModel.save()
        
        // Then
        #expect(updatedQuestion.userNote == nil)
        #expect(mockRepository.lastUpdateQuestion?.userNote == nil)
    }
    
    @Test
    func testSaveWithUpdatedNote() async throws {
        // Given
        var question = createTestQuestion()
        question.userNote = "Old note"
        let mockRepository = MockQuestionRepository()
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        viewModel.noteText = "Updated note"
        
        // When
        let updatedQuestion = try await viewModel.save()
        
        // Then
        #expect(updatedQuestion.userNote == "Updated note")
        #expect(mockRepository.lastUpdateQuestion?.userNote == "Updated note")
    }
    
    @Test
    func testSaveWithWhitespaceOnly() async throws {
        // Given
        let question = createTestQuestion()
        let mockRepository = MockQuestionRepository()
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        viewModel.noteText = "   \n\t  "
        
        // When
        let updatedQuestion = try await viewModel.save()
        
        // Then
        // Note: ViewModel only checks isEmpty, so whitespace-only strings are preserved
        // The note will contain the whitespace string since it's not empty
        #expect(updatedQuestion.userNote != nil)
        #expect(updatedQuestion.userNote == "   \n\t  ")
    }
    
    @Test
    func testSaveWithError() async {
        // Given
        let question = createTestQuestion()
        let mockRepository = MockQuestionRepository()
        let updateError = NSError(domain: "UpdateError", code: 1)
        mockRepository.updateQuestionError = updateError
        
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        viewModel.noteText = "Test note"
        
        // When/Then - Should throw error
        var didThrow = false
        var caughtError: Error?
        do {
            _ = try await viewModel.save()
        } catch {
            didThrow = true
            caughtError = error
        }
        #expect(didThrow == true)
        #expect(caughtError != nil)
        
        // Verify it's the expected error
        if let nsError = caughtError as? NSError {
            #expect(nsError.domain == "UpdateError")
            #expect(nsError.code == 1)
        }
    }
    
    @Test
    func testSavePreservesQuestionProperties() async throws {
        // Given
        var question = createTestQuestion()
        question.isFavorite = true
        question.userNote = "Original note"
        
        let mockRepository = MockQuestionRepository()
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        viewModel.noteText = "New note"
        
        // When
        let updatedQuestion = try await viewModel.save()
        
        // Then
        #expect(updatedQuestion.id == question.id)
        #expect(updatedQuestion.category == question.category)
        #expect(updatedQuestion.question == question.question)
        #expect(updatedQuestion.isFavorite == question.isFavorite)
        #expect(updatedQuestion.userNote == "New note")
    }
    
    @Test
    func testSaveMultipleTimes() async throws {
        // Given
        let question = createTestQuestion()
        let mockRepository = MockQuestionRepository()
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        
        // When
        viewModel.noteText = "First note"
        _ = try await viewModel.save()
        
        viewModel.noteText = "Second note"
        _ = try await viewModel.save()
        
        // Then
        #expect(mockRepository.updateQuestionCallCount == 2)
        #expect(mockRepository.lastUpdateQuestion?.userNote == "Second note")
    }
    
    // MARK: - Note Text Updates Tests
    
    @Test
    func testNoteTextUpdate() async {
        // Given
        let question = createTestQuestion()
        let mockRepository = MockQuestionRepository()
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        
        // When
        viewModel.noteText = "Updated text"
        
        // Then
        #expect(viewModel.noteText == "Updated text")
    }
    
    @Test
    func testNoteTextLongText() async {
        // Given
        let question = createTestQuestion()
        let mockRepository = MockQuestionRepository()
        let viewModel = NoteEditorViewModel(question: question, repository: mockRepository)
        let longText = String(repeating: "A", count: 1000)
        
        // When
        viewModel.noteText = longText
        
        // Then
        #expect(viewModel.noteText == longText)
        #expect(viewModel.noteText.count == 1000)
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
}

