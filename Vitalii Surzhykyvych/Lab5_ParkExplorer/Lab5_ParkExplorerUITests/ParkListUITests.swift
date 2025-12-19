//
//  ParkListUITests.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import XCTest

final class ParkListUITests: XCTestCase {

    func testParkListNavigation() {
        let app = XCUIApplication()
        app.launch()

        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        firstCell.tap()

        XCTAssertTrue(app.navigationBars["Park Details"].exists)
    }
}
