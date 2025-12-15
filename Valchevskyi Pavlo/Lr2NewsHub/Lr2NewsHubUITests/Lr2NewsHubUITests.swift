//
//  Lr2NewsHubUITests.swift
//  Lr2NewsHubUITests
//
//  Created by Pavlo on 14.12.2025.
//

import XCTest

final class Lr2NewsHubUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testNavigationFlow() throws {
        let app = XCUIApplication()
        
        app.launchArguments = ["-UITest"]
        app.launch()
        
        XCTAssertTrue(app.staticTexts["News Hub"].exists)
        
        let articleButton = app.buttons["Test 1"].firstMatch
        
        XCTAssertTrue(articleButton.waitForExistence(timeout: 5), "Test article 1 in list for navigation")
        
        articleButton.tap()
        
        let detailHeader = app.staticTexts["About article"]
        XCTAssertTrue(detailHeader.waitForExistence(timeout: 2))
        
        app.navigationBars.buttons.firstMatch.tap()
        
        XCTAssertTrue(app.staticTexts["News Hub"].exists)
    }
    
    func testFavoriteFilter() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITest"]
        app.launch()
        
        XCTAssertTrue(app.buttons["Test 1"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Test 2"].exists)
        
        let toggle = app.switches.firstMatch
        
        if let value = toggle.value as? String, value == "0" {
            toggle.tap()
        }
        
        XCTAssertFalse(app.buttons["Test 1"].exists, "Article 1 hide after filter favorite")
        
        XCTAssertTrue(app.buttons["Test 2"].exists, "Article 2 in list with filter")
    }
    
    func testArticleEditing() throws {
        let app = XCUIApplication()
        
        app.launchArguments = ["-UITest"]
        app.launch()

        let articleButton = app.buttons["Test 1"].firstMatch
        XCTAssertTrue(articleButton.waitForExistence(timeout: 5))
        articleButton.tap()
        
        let favoriteSwitch = app.switches.firstMatch
        if let value = favoriteSwitch.value as? String, value == "0" {
            favoriteSwitch.tap()
        }
        
        let slider = app.sliders.firstMatch
        XCTAssertTrue(slider.waitForExistence(timeout: 2), "Slider is not found")
        
        slider.adjust(toNormalizedSliderPosition: 1.0)
        
        sleep(1)
        
        let expectedLabel = "Rate article: 5"
        XCTAssertTrue(app.staticTexts[expectedLabel].exists, "User point change '\(expectedLabel)'")
        
        app.navigationBars.buttons.firstMatch.tap()
        
        XCTAssertTrue(app.staticTexts["News Hub"].waitForExistence(timeout: 2))
        
        articleButton.tap()
        
        XCTAssertTrue(app.staticTexts[expectedLabel].waitForExistence(timeout: 2), "User point save")
        
        let currentSwitchValue = app.switches.firstMatch.value as? String
        XCTAssertEqual(currentSwitchValue, "1", "Favorite is on")
    }
    
    func testCategoryPickerFilter() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITest"]
        app.launch()
        
        let pickerButton = app.buttons["FilterPicker"]
        XCTAssertTrue(pickerButton.waitForExistence(timeout: 2))
        pickerButton.tap()
        
        let changeCategory = app.buttons["Category 2"]
        XCTAssertTrue(changeCategory.waitForExistence(timeout: 2))
        changeCategory.tap()
        
        XCTAssertFalse(
            app.buttons["Test 1"].exists,
            "Article 1 should be hidden after filter"
        )
        
        XCTAssertTrue(
            app.buttons["Test 2"].exists,
            "Article 2 should be visible after filter"
        )
    }

}
