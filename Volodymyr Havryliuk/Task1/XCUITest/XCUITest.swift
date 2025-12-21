//
//  XCUITest.swift
//  XCUITest
//
//  Created by v on 17.12.2025.
//

import XCTest

final class XCUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboardApp/*@START_MENU_TOKEN@*/.staticTexts["TextContent.Primary"]/*[[".otherElements[\"NotificationBody.TopAligned.originalMessage\"].staticTexts",".otherElements",".staticTexts[\"Please log your reading progress for the day.\"]",".staticTexts[\"TextContent.Primary\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch.swipeUp()
        
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".navigationBars.buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let newBook = app/*@START_MENU_TOKEN@*/.staticTexts["New Book"]/*[[".switches.staticTexts[\"New Book\"]",".staticTexts[\"New Book\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        newBook.tap()
        
        let bookName = app/*@START_MENU_TOKEN@*/.textFields["Book Title"]/*[[".otherElements",".textFields[\"New Book\"]",".textFields[\"Book Title\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        bookName.tap()
        bookName.typeText(" 2")
        
        app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons",".buttons[\"Book Tracker\"]",".buttons[\"BackButton\"]"],[[[-1,3],[-1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        // Assert the title is now "New Book 2"
        let updatedTitle = app.staticTexts["New Book 2"].firstMatch
        XCTAssertTrue(updatedTitle.waitForExistence(timeout: 5), "Expected updated title 'New Book 2' to appear")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
