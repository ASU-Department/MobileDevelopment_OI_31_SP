//
//  WeatherWiseTestsUILaunchTests.swift
//  WeatherWiseTestsUI
//
//  Created by vburdyk on 17.12.2025.
//

import XCTest

final class WeatherScreenUITests: XCTestCase {

    func testLoadWeatherFlow() {
        let app = XCUIApplication()
        app.launch()

        let detailsButton = app.buttons["Перейти до деталей погоди"]
        XCTAssertTrue(detailsButton.exists)
        
        detailsButton.tap()
        
        let loadButton = app.buttons["Завантажити погоду"]
        XCTAssertTrue(loadButton.waitForExistence(timeout: 2))
        
        loadButton.tap()
        
        // Перевіряємо що з'явився хоч якийсь текст з температурою
        let temperatureExists = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Температура'")).firstMatch.waitForExistence(timeout: 10)
        
        XCTAssertTrue(temperatureExists, "Температура не з'явилась після завантаження")
    }
}
