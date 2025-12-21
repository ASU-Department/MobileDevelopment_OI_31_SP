//
//  CityListUITest.swift
//  lab1
//
//  Created by witold on 16.12.2025.
//

import XCTest

final class CityListUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testAppLaunches_ShowsCityList() {
        XCTAssertTrue(app.navigationBars["AirAware"].exists)
        XCTAssertTrue(app.textFields["Enter city to add"].exists)
        XCTAssertTrue(app.buttons["Search"].exists)
    }

    func testSearchCity_AddsToList() {
        let searchField = app.textFields["Enter city to add"]
        let searchButton = app.buttons["Search"]
        
        searchField.tap()
        searchField.typeText("Athena")
        searchButton.tap()
        
        let loadingIndicator = app.activityIndicators["Loading..."]
        XCTAssertTrue(
            loadingIndicator.waitForNonExistence(timeout: 5),
            "Loading should complete"
        )
        
        let athenaCell = app.staticTexts["Athena"]
        let yourLocationCell = app.staticTexts["Your location"]
        
        XCTAssertTrue(
            yourLocationCell.waitForExistence(timeout: 2),
            "Your location should appear in the list"
        )
        
        XCTAssertTrue(
            athenaCell.waitForExistence(timeout: 2),
            "Athena should appear in the list"
        )
    }


    func testSearchCity_EmptyInput_DoesNothing() {
        let searchButton = app.buttons["Search"]
        let initialCityCount = app.tables.cells.count
        
        searchButton.tap()
        
        let finalCityCount = app.tables.cells.count
        XCTAssertEqual(initialCityCount, finalCityCount, "City count should not change")
    }
    
    func testPullToRefresh_UpdatesCities() {
        let firstCity = app.buttons["CityItem_Your location"]
        XCTAssertTrue(firstCity.waitForExistence(timeout: 5))
        let lastUpdateLabel = app.staticTexts["lastUpdateLabel"]
        XCTAssertTrue(lastUpdateLabel.waitForExistence(timeout: 5))

        let initialText = lastUpdateLabel.label
        
        firstCity.swipeDown()
        
        sleep(2)
        
        let updatedText = lastUpdateLabel.label
        XCTAssertNotEqual(initialText, updatedText, "Last update should change after refresh")
    }

    func testTapCity_NavigatesToDetail() {
        let firstCityButton = app.buttons["CityItem_Kyiv"]
        XCTAssertTrue(firstCityButton.waitForExistence(timeout: 5))
        
        firstCityButton.tap()
        
        XCTAssertTrue(app.staticTexts["Air Quality Index"].waitForExistence(timeout: 5))
    }
    
    func testClearAllCities_RemovesAllItems() {
        let trashButton = app.navigationBars["AirAware"].buttons.element(matching: .button, identifier: "trash")
        
        trashButton.tap()
        
        sleep(1)
        
        let lastUpdateLabel = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Last update: None'"))
        XCTAssertTrue(lastUpdateLabel.firstMatch.exists)
    }
}
