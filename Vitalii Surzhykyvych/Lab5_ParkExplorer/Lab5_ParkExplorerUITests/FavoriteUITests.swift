//
//  FavoriteUITests.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import XCTest

final class FavoriteUITests: XCTestCase {

    func testFavoriteToggle() {
        let app = XCUIApplication()
        app.launch()

        let heart = app.buttons["heart"]
        heart.tap()

        XCTAssertTrue(app.buttons["heart.fill"].exists)
    }
}
