//
//  SpaceExplorer2_0UITests.swift
//  SpaceExplorer2.0UITests
//
//  Created by Pab1m on 14.12.2025.
//

import XCTest

final class SpaceExplorer2_0UITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testNavigateFromHomeToPictureDetail() {

        let goToDetailButton = app.buttons["Go to Picture Info →"]

        XCTAssertTrue(
            goToDetailButton.waitForExistence(timeout: 10),
            "Go to Picture Info button should exist"
        )

        goToDetailButton.tap()

        let detailTitle = app.staticTexts.element(boundBy: 0)

        XCTAssertTrue(
            detailTitle.waitForExistence(timeout: 5),
            "Picture detail screen should be presented"
        )
    }

    func testChangeTextSizeSliderOnDetailScreen() {

        let goToDetailButton = app.buttons["Go to Picture Info →"]
        XCTAssertTrue(goToDetailButton.waitForExistence(timeout: 10))
        goToDetailButton.tap()

        let slider = app.sliders.firstMatch

        XCTAssertTrue(
            slider.waitForExistence(timeout: 5),
            "Text size slider should exist on detail screen"
        )

        slider.adjust(toNormalizedSliderPosition: 0.8)

        XCTAssertTrue(slider.exists, "Slider interaction should succeed")
    }
}
