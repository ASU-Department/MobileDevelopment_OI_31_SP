//
//  CityDetailsUITests.swift
//  lab1
//
//  Created by witold on 16.12.2025.
//

import XCTest

final class CityDetailUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
        
        let firstCityButton = app.buttons["CityItem_Kyiv"]
        firstCityButton.tap()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testDetailScreen_DisplaysAQIData() {
        XCTAssertTrue(app.staticTexts["Air Quality Index"].exists)
        
        let pm25Label = app.staticTexts["PM2.5:"]
        XCTAssertTrue(pm25Label.exists)
        
        let o3Label = app.staticTexts["O3:"]
        XCTAssertTrue(o3Label.exists)
        
        let subscribeToggle = app.switches["Subscribe"]
        XCTAssertTrue(subscribeToggle.exists)
    }
    
    func testToggleSubscribe_ChangesState() {
        let subscribeToggle = app.switches["Subscribe"]
        let initialValue = subscribeToggle.value as? String
        
        subscribeToggle.tap()
        
        sleep(1)
        
        let newValue = subscribeToggle.value as? String
        XCTAssertNotEqual(initialValue, newValue, "Toggle state should change")
    }
}
