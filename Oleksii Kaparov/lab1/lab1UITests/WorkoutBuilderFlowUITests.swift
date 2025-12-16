//
//  WorkoutBuilderFlowUITests.swift
//  lab1UITests
//
//  Created by A-Z pack group on 16.12.2025.
//
import XCTest

final class WorkoutBuilderFlowUITests: XCTestCase {

    func test_saveWithoutExercises_doesNotCreateWorkout() {
        let app = launchForUITesting()

        enterWorkoutName("UI Push Day", app: app)

        let saveButton = app.buttons["saveWorkoutButton"]
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()

        openSavedScreen(app: app)

       
        let exists = savedListContains(app: app, name: "UI Push Day")
        XCTAssertFalse(exists, "Workout should NOT exist when saved without exercises.")
    }

    func test_createWorkout_appearsInSavedList() {
        let app = launchForUITesting()

        enterWorkoutName("UI Push Day", app: app)

        let addButton = app.buttons["addExerciseButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2))
        addButton.tap()

        let saveButton = app.buttons["saveWorkoutButton"]
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()

        openSavedScreen(app: app)

        let exists = waitForSavedListContains(app: app, name: "UI Push Day", timeout: 8)
        XCTAssertTrue(exists, "Workout should exist after adding an exercise and saving.")
    }
}
