//
//  WeatherWiseTestsUI.swift
//  WeatherWiseTestsUI
//
//  Created by vburdyk on 17.12.2025.
//

import XCTest

final class SettingsScreenUITests: XCTestCase {

    func testSettingsScreen() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Налаштування"].exists)
        XCTAssertTrue(app.buttons["Перейти до деталей погоди"].exists)
    }
}
