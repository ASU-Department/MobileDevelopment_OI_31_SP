import XCTest

final class SearchFlow_UITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testSearchAndToggleFavoritesFilter() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        // ✅ Дочекайся що апка реально в foreground і має вікно
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))

        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))

        // ✅ Гарантуємо фокус і чисте поле
        searchField.tap()
        if let value = searchField.value as? String, !value.isEmpty {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: value.count)
            searchField.typeText(deleteString)
        }

        // ✅ Після tap поле має бути hittable
        XCTAssertTrue(searchField.isHittable)
        searchField.typeText("Mock")

        let searchButton = app.buttons["searchButton"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 10))
        searchButton.tap()

        let resultsList = app.tables["searchResultsList"]
        XCTAssertTrue(resultsList.waitForExistence(timeout: 10))

        // В mock repo є trackId 1
        let firstRow = resultsList.otherElements["songRow.1"]
        XCTAssertTrue(firstRow.waitForExistence(timeout: 10))

        let favButton = resultsList.buttons["favoriteButton.1"]
        XCTAssertTrue(favButton.waitForExistence(timeout: 10))
        favButton.tap()

        let toggle = app.switches["showOnlyFavoritesToggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 10))
        toggle.tap()

        XCTAssertTrue(firstRow.exists)
    }
}
