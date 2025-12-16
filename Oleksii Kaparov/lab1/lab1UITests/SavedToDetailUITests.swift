//
//  SavedToDetailUITests.swift
//  lab1UITests
//
//  Created by A-Z pack group on 16.12.2025.
//
import XCTest

final class SavedToDetailUITests: XCTestCase {

    func test_openSavedAndOpenDetail_showsWorkoutInfo() {
        let app = launchForUITesting()

        // Створюємо тренування
        enterWorkoutName("UI Legs", app: app)

        let addButton = app.buttons["addExerciseButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        addButton.tap()

        let saveButton = app.buttons["saveWorkoutButton"]
        XCTAssertTrue(saveButton.exists)
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()

        // Відкриваємо Saved
        openSavedScreen(app: app)

        let cell = findSavedWorkoutCell(app: app, name: "UI Legs", timeout: 8)
        XCTAssertTrue(cell.exists)
        cell.tap()

        // Detail
        let title = app.staticTexts["detailWorkoutTitle"]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        XCTAssertEqual(title.label, "UI Legs")

        XCTAssertTrue(app.buttons["shareWorkoutButton"].exists)
    }
}
