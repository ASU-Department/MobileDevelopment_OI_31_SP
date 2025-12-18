import XCTest

final class Lab5_TimeCapsuleUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        
        app.launchArguments.append("UI_TESTS")
        app.launch()
    }
    
    func testHomeScreenContentAndNavigation() {
        let loadingIndicator = app.activityIndicators["loadingIndicator"]
        if loadingIndicator.exists {
            let _ = loadingIndicator.waitForExistence(timeout: 0.5)
            let predicate = NSPredicate(format: "exists == false")
            expectation(for: predicate, evaluatedWith: loadingIndicator, handler: nil)
            waitForExpectations(timeout: 5.0, handler: nil)
        }
        
        if app.staticTexts["emptyStateView"].exists {
            print("Empty screen detected. Attempting Pull to Refresh...")
            let list = app.collectionViews["eventsList"]
            if list.exists {
                let start = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
                let end = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
                start.press(forDuration: 0.1, thenDragTo: end)
            }
        }
        
        let eventText = app.staticTexts["Test Event for UI"]
        
        if !eventText.waitForExistence(timeout: 10) {
            print("Event text not found! Element hierarchy:")
            print(app.debugDescription)
            XCTFail("Event list failed to load or does not contain test data")
            return
        }
        
        XCTAssertTrue(eventText.exists, "The event 'Test Event for UI' should be visible")
        
        eventText.tap()
        
        let detailTitle = app.staticTexts["Details"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 5), "Details screen did not open")
        
        let yearText = app.staticTexts["2024"]
        XCTAssertTrue(yearText.exists, "Year 2024 should be visible on the details screen")
    }
    
    func testSettingsInteraction() {
        let settingsButton = app.buttons["settingsButton"].firstMatch
        let settingsImage = app.images["settingsButton"].firstMatch
            
        if settingsButton.waitForExistence(timeout: 5) {
            settingsButton.tap()
        } else if settingsImage.waitForExistence(timeout: 5) {
            settingsImage.tap()
        } else {
            print("Settings button not found. Hierarchy:")
            print(app.debugDescription)
            XCTFail("Settings button is missing from the toolbar")
        }
            
        let settingsTitle = app.staticTexts["Settings"]
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 5), "Settings screen did not open")
            
        let slider = app.sliders.firstMatch
        XCTAssertTrue(slider.waitForExistence(timeout: 3), "Font size slider should be present")
            
        slider.adjust(toNormalizedSliderPosition: 0.5)
    }
        
    func testFavoriteToggleLogic() {
        let eventText = app.staticTexts["Test Event for UI"]
        XCTAssertTrue(eventText.waitForExistence(timeout: 5), "Event must be in the list to test favorites")
        eventText.tap()
            
        let detailTitle = app.staticTexts["Details"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 3))
            
        let favButton = app.buttons["favoriteButton"]
        XCTAssertTrue(favButton.exists, "'Add to Favorites' button must exist")
            
        XCTAssertTrue(favButton.staticTexts["Add to Favorites"].exists, "Initial button state must be 'Add to Favorites'")
            
        favButton.tap()
            
        let removeText = favButton.staticTexts["Remove from Favorites"]
        XCTAssertTrue(removeText.waitForExistence(timeout: 2), "Button should have changed state to 'Remove from Favorites'")
            
        favButton.tap()
            
        XCTAssertTrue(favButton.staticTexts["Add to Favorites"].waitForExistence(timeout: 2), "Button should have returned to 'Add to Favorites' state")
    }
}