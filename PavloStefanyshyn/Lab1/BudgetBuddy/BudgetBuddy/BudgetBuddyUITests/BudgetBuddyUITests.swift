//
//  BudgetBuddyUITests.swift
//  BudgetBuddyUITests
//
//  Created by Nill on 16.12.2025.
//

import XCTest

final class BudgetBuddyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddExpenseAppearsInList() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Add New Expense"].tap()

        let titleField = app.textFields["Title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("Taxi")

        let amountField = app.textFields["Amount"]
        XCTAssertTrue(amountField.waitForExistence(timeout: 2))
        amountField.tap()
        amountField.typeText("200")

        app.buttons["Save"].tap()

        let taxiText = app.staticTexts["Taxi"]
        XCTAssertTrue(taxiText.waitForExistence(timeout: 2))
    }


    func testEmptyAmountShowsError() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Add New Expense"].tap()
        
        let titleField = app.textFields["Title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("Error test")
        
        app.buttons["Save"].tap()

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 2))
    }

    

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

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
