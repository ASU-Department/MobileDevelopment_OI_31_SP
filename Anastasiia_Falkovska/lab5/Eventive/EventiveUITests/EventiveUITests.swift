import XCTest

final class EventiveUITests: XCTestCase {

    func test_appLaunches_andSearchButtonExists() {
        let app = XCUIApplication()
        app.launch()

        let button = app.buttons["Шукати"]
        XCTAssertTrue(button.waitForExistence(timeout: 3))
    }

    func test_search_flow_doesNotCrash() {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["Пошук за місцем / ім'ям"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))

        searchField.tap()
        searchField.typeText("music")
        app.keyboards.buttons["Return"].tap()

        let button = app.buttons["Шукати"]
        XCTAssertTrue(button.waitForExistence(timeout: 3))
        button.tap()

        // Either results list OR error message should appear
        let table = app.tables.firstMatch
        let errorText = app.staticTexts.firstMatch

        XCTAssertTrue(
            table.waitForExistence(timeout: 5) ||
            errorText.waitForExistence(timeout: 5)
        )
    }
}
