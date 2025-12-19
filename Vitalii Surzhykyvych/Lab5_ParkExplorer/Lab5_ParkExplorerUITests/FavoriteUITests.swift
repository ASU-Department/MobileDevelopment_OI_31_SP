//
//  FavoriteUITests.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import XCTest

final class FavoriteUITests: XCTestCase {

    func testFavoriteToggleInDetailView() {
        let app = XCUIApplication()
        app.launch()

        let list = app.tables.firstMatch
        XCTAssertTrue(list.waitForExistence(timeout: 100))

        let firstCell = list.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 100))
        firstCell.tap()

        let heartOff = app.buttons["favorite_off"]
        XCTAssertTrue(heartOff.waitForExistence(timeout: 50))
        heartOff.tap()

        XCTAssertTrue(app.buttons["favorite_on"].exists)
    }
}
