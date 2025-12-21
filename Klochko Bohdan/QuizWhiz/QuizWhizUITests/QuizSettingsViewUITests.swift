//
//  QuizSettingsViewUITests.swift
//  QuizWhizUITests
//
//  Created for Lab 5 - UI Testing
//

import XCTest

final class QuizSettingsViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Initial State Tests
    
    @MainActor
    func testInitialState() throws {
        // Verify the main elements are present
        XCTAssertTrue(app.staticTexts["Quiz Settings"].exists)
        XCTAssertTrue(app.steppers.firstMatch.exists)
        XCTAssertTrue(app.switches.firstMatch.exists)
        XCTAssertTrue(app.buttons["View Favorites"].exists)
    }
    
    // MARK: - Question Count Tests
    
    @MainActor
    func testQuestionCountStepper() throws {
        // Find the stepper
        let stepper = app.steppers.firstMatch
        XCTAssertTrue(stepper.exists)
        
        // Get initial value
        let initialText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Questions:'")).firstMatch.label
        
        // Increment stepper
        let incrementButton = stepper.buttons["Increment"]
        if incrementButton.exists {
            incrementButton.tap()
            
            // Verify the count increased
            let newText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Questions:'")).firstMatch.label
            XCTAssertNotEqual(initialText, newText)
        }
    }
    
    @MainActor
    func testQuestionCountDecrement() throws {
        // Find the stepper
        let stepper = app.steppers.firstMatch
        XCTAssertTrue(stepper.exists)
        
        // Get initial value
        let initialText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Questions:'")).firstMatch.label
        
        // Decrement stepper
        let decrementButton = stepper.buttons["Decrement"]
        if decrementButton.exists {
            decrementButton.tap()
            
            // Verify the count decreased
            let newText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Questions:'")).firstMatch.label
            XCTAssertNotEqual(initialText, newText)
        }
    }
    
    // MARK: - Hard Mode Toggle Tests
    
    @MainActor
    func testHardModeToggle() throws {
        // Find the hard mode toggle
        let toggle = app.switches.firstMatch
        XCTAssertTrue(toggle.exists)
        
        // Get initial state
        let initialValue = toggle.value as? String ?? "0"
        
        // Toggle it
        toggle.tap()
        
        // Verify state changed
        let newValue = toggle.value as? String ?? "0"
        XCTAssertNotEqual(initialValue, newValue)
    }
    
    @MainActor
    func testHardModeToggleMultipleTimes() throws {
        let toggle = app.switches.firstMatch
        XCTAssertTrue(toggle.exists)
        
        // Toggle multiple times
        toggle.tap()
        let value1 = toggle.value as? String ?? "0"
        
        toggle.tap()
        let value2 = toggle.value as? String ?? "0"
        
        // Verify it toggles correctly
        XCTAssertNotEqual(value1, value2)
    }
    
    // MARK: - Category Selection Tests
    
    @MainActor
    func testCategoryPickerExists() throws {
        // Verify category picker is present
        // The picker might be implemented as buttons or a segmented control
        // We'll check for any interactive element in the category section
        let categorySection = app.scrollViews.firstMatch
        XCTAssertTrue(categorySection.exists)
    }
    
    // MARK: - Navigation Tests
    
    @MainActor
    func testNavigateToFavorites() throws {
        // Find and tap the "View Favorites" button
        let favoritesButton = app.buttons["View Favorites"]
        XCTAssertTrue(favoritesButton.exists)
        
        favoritesButton.tap()
        
        // Wait for navigation
        let favoritesTitle = app.navigationBars["Favorites"]
        let exists = favoritesTitle.waitForExistence(timeout: 2.0)
        XCTAssertTrue(exists, "Should navigate to Favorites view")
    }
    
    @MainActor
    func testNavigateBackFromFavorites() throws {
        // Navigate to favorites
        let favoritesButton = app.buttons["View Favorites"]
        favoritesButton.tap()
        
        // Wait for favorites view
        let favoritesTitle = app.navigationBars["Favorites"]
        _ = favoritesTitle.waitForExistence(timeout: 2.0)
        
        // Navigate back
        let backButton = app.navigationBars.buttons.firstMatch
        if backButton.exists {
            backButton.tap()
            
            // Verify we're back at settings
            let settingsTitle = app.staticTexts["Quiz Settings"]
            let exists = settingsTitle.waitForExistence(timeout: 2.0)
            XCTAssertTrue(exists, "Should navigate back to Settings view")
        }
    }
    
    // MARK: - Start Quiz Navigation Tests
    
    @MainActor
    func testStartQuizButtonExists() throws {
        // Find the start button by its text
        let startButton = app.buttons["Start Quiz"]
        XCTAssertTrue(startButton.exists, "Start Quiz button should exist")
    }
    
    // MARK: - Last Update Text Tests
    
    @MainActor
    func testLastUpdateTextDisplayed() throws {
        // Verify that last update text is displayed
        // It should either show "No updates yet" or "Last updated:"
        let updateText = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Last updated' OR label CONTAINS 'No updates'")).firstMatch
        XCTAssertTrue(updateText.exists, "Last update text should be displayed")
    }
    
    // MARK: - Complete Flow Test
    
    @MainActor
    func testCompleteSettingsFlow() throws {
        // 1. Change question count
        let stepper = app.steppers.firstMatch
        if stepper.exists {
            let incrementButton = stepper.buttons["Increment"]
            if incrementButton.exists {
                incrementButton.tap()
            }
        }
        
        // 2. Toggle hard mode
        let toggle = app.switches.firstMatch
        if toggle.exists {
            toggle.tap()
        }
        
        // 3. Navigate to favorites
        let favoritesButton = app.buttons["View Favorites"]
        if favoritesButton.exists {
            favoritesButton.tap()
            
            // Wait for navigation
            let favoritesTitle = app.navigationBars["Favorites"]
            _ = favoritesTitle.waitForExistence(timeout: 2.0)
            
            // Navigate back
            let backButton = app.navigationBars.buttons.firstMatch
            if backButton.exists {
                backButton.tap()
            }
        }
        
        // Verify we're back at settings
        let settingsTitle = app.staticTexts["Quiz Settings"]
        let exists = settingsTitle.waitForExistence(timeout: 2.0)
        XCTAssertTrue(exists, "Should be back at Settings view")
    }
}

