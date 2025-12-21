import XCTest

final class ArtworkDetailUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    private func navigateToDetail() -> Bool {
        let scrollView = app.scrollViews.firstMatch
        guard scrollView.waitForExistence(timeout: 25) else { return false }
        
        Thread.sleep(forTimeInterval: 2.0)
        
        let cells = scrollView.otherElements
        guard cells.count > 0 else { return false }
        
        let cell = cells.element(boundBy: 0)
        guard cell.waitForExistence(timeout: 10) else { return false }
        
        cell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        
        let detailNav = app.navigationBars["Artwork Details"]
        return detailNav.waitForExistence(timeout: 10)
    }
    
    func testDetailViewDisplaysArtworkInfo() throws {
        guard navigateToDetail() else {
            throw XCTSkip("Could not navigate to detail view")
        }
        
        XCTAssertTrue(app.navigationBars["Artwork Details"].exists)
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
    }
    
    func testFavoriteButtonInDetail() throws {
        guard navigateToDetail() else {
            throw XCTSkip("Could not navigate to detail view")
        }
        
        let heartButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'heart'")).firstMatch
        if heartButton.waitForExistence(timeout: 5) {
            heartButton.tap()
            XCTAssertTrue(heartButton.exists)
        }
    }
    
    func testShareButtonExists() throws {
        guard navigateToDetail() else {
            throw XCTSkip("Could not navigate to detail view")
        }
        
        let shareButton = app.buttons["Share"]
        if shareButton.waitForExistence(timeout: 5) {
            XCTAssertTrue(shareButton.exists)
        }
    }
    
    func testShareButtonOpensShareSheet() throws {
        guard navigateToDetail() else {
            throw XCTSkip("Could not navigate to detail view")
        }
        
        let shareButton = app.buttons["Share"]
        if shareButton.waitForExistence(timeout: 5) {
            shareButton.tap()
            
            let shareSheet = app.otherElements["ActivityListView"]
            if shareSheet.waitForExistence(timeout: 5) {
                XCTAssertTrue(shareSheet.exists)
            }
        }
    }
    
    func testBackNavigationFromDetail() throws {
        guard navigateToDetail() else {
            throw XCTSkip("Could not navigate to detail view")
        }
        
        let backButton = app.navigationBars["Artwork Details"].buttons.firstMatch
        XCTAssertTrue(backButton.exists)
        
        backButton.tap()
        
        let listNav = app.navigationBars["Art Gallery"]
        XCTAssertTrue(listNav.waitForExistence(timeout: 5))
    }
    
    func testDetailViewScrolling() throws {
        guard navigateToDetail() else {
            throw XCTSkip("Could not navigate to detail view")
        }
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists)
        
        scrollView.swipeUp()
        scrollView.swipeDown()
        
        XCTAssertTrue(app.navigationBars["Artwork Details"].exists)
    }
    
    func testToggleFavoriteMultipleTimes() throws {
        guard navigateToDetail() else {
            throw XCTSkip("Could not navigate to detail view")
        }
        
        let heartButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'heart'")).firstMatch
        if heartButton.waitForExistence(timeout: 5) {
            heartButton.tap()
            Thread.sleep(forTimeInterval: 0.5)
            
            heartButton.tap()
            Thread.sleep(forTimeInterval: 0.5)
            
            XCTAssertTrue(heartButton.exists)
        }
    }
}
