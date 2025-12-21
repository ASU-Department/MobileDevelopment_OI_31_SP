//
//  QuizSettingsViewModelTests.swift
//  QuizWhizTests
//
//  Created for Lab 5 - Using Swift Testing
//

import Testing
import Foundation
@testable import QuizWhiz

@MainActor
struct QuizSettingsViewModelTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func testInitialization() async {
        // Given
        let initialQuestionCount = UserPreferences.questionsPerPage
        
        // When
        let viewModel = QuizSettingsViewModel()
        
        // Then
        #expect(viewModel.questionCount == initialQuestionCount)
        #expect(viewModel.selectedCategory.name == categories.first!.name)
        #expect(viewModel.isHardMode == false)
    }
    
    // MARK: - Question Count Tests
    
    @Test
    func testUpdateQuestionCount() async {
        // Given
        let viewModel = QuizSettingsViewModel()
        let newCount = 15
        
        // When
        viewModel.updateQuestionCount(newCount)
        
        // Then
        #expect(viewModel.questionCount == 15)
        #expect(UserPreferences.questionsPerPage == 15)
    }
    
    @Test
    func testUpdateQuestionCountMultipleTimes() async {
        // Given
        let viewModel = QuizSettingsViewModel()
        
        // When
        viewModel.updateQuestionCount(5)
        viewModel.updateQuestionCount(10)
        viewModel.updateQuestionCount(20)
        
        // Then
        #expect(viewModel.questionCount == 20)
        #expect(UserPreferences.questionsPerPage == 20)
    }
    
    // MARK: - Category Selection Tests
    
    @Test
    func testCategorySelection() async {
        // Given
        let viewModel = QuizSettingsViewModel()
        let newCategory = Category(name: "History")
        
        // When
        viewModel.selectedCategory = newCategory
        
        // Then
        #expect(viewModel.selectedCategory.name == "History")
    }
    
    @Test
    func testCategorySelectionChange() async {
        // Given
        let viewModel = QuizSettingsViewModel()
        let initialCategory = viewModel.selectedCategory
        
        // When
        viewModel.selectedCategory = Category(name: "Sports")
        
        // Then
        #expect(viewModel.selectedCategory.name != initialCategory.name)
        #expect(viewModel.selectedCategory.name == "Sports")
    }
    
    // MARK: - Hard Mode Tests
    
    @Test
    func testHardModeToggle() async {
        // Given
        let viewModel = QuizSettingsViewModel()
        #expect(viewModel.isHardMode == false)
        
        // When
        viewModel.isHardMode = true
        
        // Then
        #expect(viewModel.isHardMode == true)
    }
    
    @Test
    func testHardModeToggleMultipleTimes() async {
        // Given
        let viewModel = QuizSettingsViewModel()
        
        // When
        viewModel.isHardMode = true
        viewModel.isHardMode = false
        viewModel.isHardMode = true
        
        // Then
        #expect(viewModel.isHardMode == true)
    }
    
    // MARK: - Last Update Text Tests
    
    @Test
    func testLastUpdateTextWithNoTimestamp() async {
        // Given
        UserPreferences.lastUpdateTimestamp = nil
        let viewModel = QuizSettingsViewModel()
        
        // When
        let text = viewModel.lastUpdateText
        
        // Then
        #expect(text == "No updates yet")
    }
    
    @Test
    func testLastUpdateTextWithTimestamp() async {
        // Given
        let timestamp = Date().addingTimeInterval(-3600) // 1 hour ago
        UserPreferences.lastUpdateTimestamp = timestamp
        let viewModel = QuizSettingsViewModel()
        
        // When
        let text = viewModel.lastUpdateText
        
        // Then
        #expect(text.contains("Last updated:"))
    }
    
    @Test
    func testLastUpdateTextFormat() async {
        // Given
        let timestamp = Date()
        UserPreferences.lastUpdateTimestamp = timestamp
        let viewModel = QuizSettingsViewModel()
        
        // When
        let text = viewModel.lastUpdateText
        
        // Then
        #expect(text.starts(with: "Last updated:"))
    }
    
    // MARK: - State Transitions Tests
    
    @Test
    func testCompleteStateTransition() async {
        // Given
        let viewModel = QuizSettingsViewModel()
        
        // When
        viewModel.selectedCategory = Category(name: "Music")
        viewModel.updateQuestionCount(15)
        viewModel.isHardMode = true
        
        // Then
        #expect(viewModel.selectedCategory.name == "Music")
        #expect(viewModel.questionCount == 15)
        #expect(viewModel.isHardMode == true)
        #expect(UserPreferences.questionsPerPage == 15)
    }
    
    @Test
    func testQuestionCountPersistence() async {
        // Given
        let viewModel1 = QuizSettingsViewModel()
        viewModel1.updateQuestionCount(12)
        
        // When
        let viewModel2 = QuizSettingsViewModel()
        
        // Then
        #expect(viewModel2.questionCount == 12)
    }
}

