//
//  FavoriteUITests.swift
//  ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import XCTest

final class FavoriteUITests: XCTestCase {

    func testFavoriteToggle() {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TEST_MODE")
        app.launch()

        let cell = app.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))

        let heart = app.buttons
            .matching(identifier: "favorite_list_ui-test")
            .firstMatch

        XCTAssertTrue(heart.exists)
        heart.tap()
    }
}
