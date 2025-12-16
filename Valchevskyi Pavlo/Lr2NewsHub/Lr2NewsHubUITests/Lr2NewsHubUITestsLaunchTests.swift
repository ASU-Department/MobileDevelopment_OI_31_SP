//
//  Lr2NewsHubUITestsLaunchTests.swift
//  Lr2NewsHubUITests
//
//  Created by Pavlo on 14.12.2025.
//

import XCTest

final class Lr2NewsHubUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITest"]
        app.launch()
        
        let title = app.staticTexts["News Hub"]
        XCTAssertTrue(title.waitForExistence(timeout: 3))
        
        let picker = app.buttons["FilterPicker"]
        XCTAssertTrue(picker.exists, "Picker not found")
        
        let favoriteToggle = app.switches.firstMatch
        XCTAssertTrue(favoriteToggle.exists)
        
        let list = app.collectionViews["ArticlesList"]
        XCTAssertTrue(list.waitForExistence(timeout: 3), "List not found")

        let firstArticle = list.cells.firstMatch
        XCTAssertTrue(firstArticle.waitForExistence(timeout: 5), "Data not found")
        
        let footer = app.staticTexts["(c) News Hub"]
        XCTAssertTrue(footer.exists)
    }
}
