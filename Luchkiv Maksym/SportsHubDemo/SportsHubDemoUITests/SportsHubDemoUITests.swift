//
//  SportsHubDemoUITests.swift
//  SportsHubDemoUITests
//
//  Created by Maksym on 17.12.2025.
//
import XCTest

@MainActor
final class SportsHubDemoUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        try await super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UI_TESTS")
        app.launch()
    }

    func testManageFavoritesAndFilteringFlow() throws {
        let firstRow = app.descendants(matching: .any).matching(identifier: "gameRow_LAL_GSW").firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))

        let manageFavorites = app.buttons["manageFavoritesButton"]
        XCTAssertTrue(manageFavorites.waitForExistence(timeout: 2))
        manageFavorites.tap()

        let staticTextsQuery = app.staticTexts
        let atlantaHawksElementsQuery = staticTextsQuery.matching(identifier: "Los Angeles Lakers")
        XCTAssertTrue(manageFavorites.waitForExistence(timeout: 2))
        atlantaHawksElementsQuery.element(boundBy: 0).tap()

        let doneButton = app.buttons["favoritesDoneButton"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()

        XCTAssertTrue(app.staticTexts["Los Angeles Lakers favorite"].waitForExistence(timeout: 2))

        let liveToggle = app.switches["LiveOnlyToggleIdentifier"]
        XCTAssertTrue(liveToggle.waitForExistence(timeout: 2))

        let finalGameRow = app.staticTexts["Brooklyn Nets @ New York Knicks"].firstMatch
        XCTAssertTrue(finalGameRow.waitForExistence(timeout: 2))

        app.switches["1"].firstMatch.tap() // filter live only
        XCTAssertFalse(finalGameRow.waitForExistence(timeout: 2))

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("Bull")

        let filteredRow = app.staticTexts["Miami Heat @ Chicago Bulls"].firstMatch
        XCTAssertTrue(filteredRow.waitForExistence(timeout: 2))
    }

    func testGameDetailPredictionAndShare() throws {
        let firstRow = app.descendants(matching: .any).matching(identifier: "gameRow_LAL_GSW").firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5))
        firstRow.tap()

        let slider = app.sliders.firstMatch
        XCTAssertTrue(slider.waitForExistence(timeout: 2))
        slider.adjust(toNormalizedSliderPosition: 0.75)

        let predictionLabel = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Home margin")).firstMatch
        XCTAssertTrue(predictionLabel.waitForExistence(timeout: 2))

        app.buttons["shareButton"].tap()
        let shareSheet = app.otherElements["ActivityListView"]
        let actionSheet = app.sheets.firstMatch
        XCTAssertTrue(shareSheet.waitForExistence(timeout: 3) || actionSheet.waitForExistence(timeout: 3))

        if app.buttons["Close"].exists {
            app.buttons["Close"].tap()
        } else if app.buttons["Cancel"].exists {
            app.buttons["Cancel"].tap()
        }
    }
}
