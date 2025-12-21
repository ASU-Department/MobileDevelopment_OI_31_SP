import XCTest

final class FavoritesFlow_UITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testAddFavoriteThenOpenFavoritesAndClearAll() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))

        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))

        searchField.tap()
        XCTAssertTrue(searchField.isHittable)
        searchField.typeText("Mock")

        let searchButton = app.buttons["searchButton"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 10))
        searchButton.tap()

        let resultsList = app.tables["searchResultsList"]
        XCTAssertTrue(resultsList.waitForExistence(timeout: 100))

        let favButton = resultsList.buttons["favoriteButton.1"]
        XCTAssertTrue(favButton.waitForExistence(timeout: 10))
        favButton.tap()

        let navFav = app.buttons["navFavoritesButton"]
        XCTAssertTrue(navFav.waitForExistence(timeout: 10))
        navFav.tap()

        let favoritesList = app.tables["favoritesList"]
        XCTAssertTrue(favoritesList.waitForExistence(timeout: 10))

        let row = favoritesList.otherElements["songRow.1"]
        XCTAssertTrue(row.waitForExistence(timeout: 10))

        let clearAll = app.buttons["clearAllFavoritesButton"]
        XCTAssertTrue(clearAll.waitForExistence(timeout: 10))
        clearAll.tap()

        let emptyState = app.otherElements["favoritesEmptyState"]
        XCTAssertTrue(emptyState.waitForExistence(timeout: 10))
    }
}
