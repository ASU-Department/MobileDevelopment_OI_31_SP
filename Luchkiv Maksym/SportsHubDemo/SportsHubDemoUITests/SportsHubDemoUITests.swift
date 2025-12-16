import XCTest

final class SportsHubDemoUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
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

        let favoritesTable = app.tables.firstMatch
        XCTAssertTrue(favoritesTable.waitForExistence(timeout: 2))
        favoritesTable.cells.staticTexts["Los Angeles Lakers"].tap()

        let doneButton = app.buttons["favoritesDoneButton"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()

        XCTAssertTrue(app.staticTexts["LAL"].waitForExistence(timeout: 2))

        let liveToggle = app.switches["Live only"]
        XCTAssertTrue(liveToggle.waitForExistence(timeout: 2))
        if let value = liveToggle.value as? String, value == "1" {
            liveToggle.tap() // show all games
        }

        let finalGameRow = app.descendants(matching: .any).matching(identifier: "gameRow_BKN_BOS").firstMatch
        XCTAssertTrue(finalGameRow.waitForExistence(timeout: 2))

        liveToggle.tap() // filter live only
        XCTAssertFalse(finalGameRow.waitForExistence(timeout: 2))

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        searchField.tap()
        searchField.typeText("Mavs")

        let filteredRow = app.descendants(matching: .any).matching(identifier: "gameRow_DAL_PHX").firstMatch
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
