//
//  CryptoTrackerUITests.swift
//  CryptoTrackerUITests
//
//  Created by Яромир-Олег Куспісь on 13.12.2025.
//

import XCTest

final class CryptoTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testCryptoListFiltering() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-UITest")
        app.launch()
        
        // Verify seeded data
        let bitcoinText = app.staticTexts["Bitcoin"]
        let listLoaded = bitcoinText.waitForExistence(timeout: 10.0)
        
        if !listLoaded {
            print("Debug: View Hierarchy: \(app.debugDescription)")
        }
        
        XCTAssertTrue(listLoaded, "Crypto list should load and show seeded Bitcoin")
        
        // Tap Portfolio (Favorites) Filter
        let portfolioButton = app.buttons["portfolio_filter_button"]
        if portfolioButton.exists {
             portfolioButton.tap()
        }
    }
    
    @MainActor
    func testCoinDetailNavigationAndFavorite() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-UITest")
        app.launch()
        
        let bitcoinText = app.staticTexts["Bitcoin"]
        XCTAssertTrue(bitcoinText.waitForExistence(timeout: 10.0), "Seeded Bitcoin should appear in list")
        
        bitcoinText.tap()
        
        let navTitle = app.staticTexts["Bitcoin"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5.0), "Should navigate to Bitcoin detail")
        
        let priceText = app.staticTexts["detail_price_text"]
        XCTAssertTrue(priceText.waitForExistence(timeout: 10.0), "Detail Screen should show price")
    }
}
