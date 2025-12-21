//
//  UITestHelpers.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//


import XCTest

enum UITestHelpers {

    static func launchApp(
        file: StaticString = #file,
        line: UInt = #line
    ) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-testing")
        app.launch()

        XCTAssertTrue(
            app.waitForExistence(timeout: 5),
            "App failed to launch",
            file: file,
            line: line
        )

        return app
    }

    static func waitForElement(
        _ element: XCUIElement,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            element.waitForExistence(timeout: timeout),
            "Element \(element) did not appear",
            file: file,
            line: line
        )
    }
}
