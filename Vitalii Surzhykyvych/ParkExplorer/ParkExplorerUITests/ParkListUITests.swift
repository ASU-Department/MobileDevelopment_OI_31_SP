//
//  ParkListUITests.swift
//  ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import XCTest

final class ParkListUITests: XCTestCase {

    func testParkListNavigation() {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TEST_MODE")
        app.launch()

        let parkCell = app.staticTexts["UI Test Park"]
        XCTAssertTrue(parkCell.waitForExistence(timeout: 5))

        parkCell.tap()

        XCTAssertTrue(app.navigationBars["Park Details"].exists)
    }
}
