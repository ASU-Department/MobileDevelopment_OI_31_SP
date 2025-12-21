//
//  habitBuddyUITests.swift
//  habitBuddyUITests
//
//  Created by  User on 23.10.2025.
//

import XCTest

final class habitBuddyUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testAddHabitSuccessAppearsInList() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["contentAddHabitButton"].tap()

        let nameField = app.textFields["addHabitNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("UI Test Habit")

        let descField = app.textFields["addHabitDescField"]
        descField.tap()
        descField.typeText("Created from UI test")

        app.buttons["addHabitSaveButton"].tap()

        let habitCell = app.staticTexts["habitCell_UI Test Habit"]
        XCTAssertTrue(habitCell.waitForExistence(timeout: 3))
    }
    
    func testEditHabitUpdatesStreak() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["contentAddHabitButton"].tap()

        let nameField = app.textFields["addHabitNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("Editable Habit")

        let descField = app.textFields["addHabitDescField"]
        descField.tap()
        descField.typeText("For edit test")

        app.buttons["addHabitSaveButton"].tap()

        let habitCell = app.staticTexts["habitCell_Editable Habit"]
        XCTAssertTrue(habitCell.waitForExistence(timeout: 3))
        habitCell.tap()

        let detailNameField = app.textFields["detailNameField"]
        XCTAssertTrue(detailNameField.waitForExistence(timeout: 2))
        detailNameField.tap()
        detailNameField.clearAndEnterText("Edited Habit")

        let stepper = app.steppers["detailStreakStepper"]
        stepper.buttons.element(boundBy: 1).tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()

        let editedCell = app.staticTexts["habitCell_Edited Habit"]
        XCTAssertTrue(editedCell.waitForExistence(timeout: 3))
    }
}

extension XCUIElement {
    func clearAndEnterText(_ text: String) {
        tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: value as? String != nil ? (value as! String).count : 0)
        typeText(deleteString)
        typeText(text)
    }
}
