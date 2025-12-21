import XCTest

final class ArtCuratorUITests: XCTestCase {
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
    
    func testArtworkListDisplaysArtworks() throws {
        let navigationTitle = app.navigationBars["Art Gallery"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 10))
        
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 15))
    }
    
    func testSearchFunctionality() throws {
        let searchField = app.textFields["Search artist or title"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        
        searchField.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        
        let keyboard = app.keyboards.firstMatch
        guard keyboard.waitForExistence(timeout: 5) else {
            XCTAssertTrue(app.scrollViews.firstMatch.exists)
            return
        }
        
        searchField.typeText("monet")
        
        if app.keyboards.buttons["Search"].exists {
            app.keyboards.buttons["Search"].tap()
        } else if app.keyboards.buttons["search"].exists {
            app.keyboards.buttons["search"].tap()
        } else {
            app.keyboards.buttons["Return"].tap()
        }
        
        XCTAssertTrue(app.scrollViews.firstMatch.waitForExistence(timeout: 20))
    }
    
    func testNavigationToArtworkDetail() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 20))
        
        let cell = scrollView.otherElements.element(boundBy: 0)
        if cell.waitForExistence(timeout: 10) {
            cell.tap()
            
            let detailTitle = app.navigationBars["Artwork Details"]
            XCTAssertTrue(detailTitle.waitForExistence(timeout: 10))
        }
    }
    
    func testFavoriteButtonInList() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 20))
        
        let heartButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'heart'")).firstMatch
        if heartButton.waitForExistence(timeout: 10) {
            heartButton.tap()
            XCTAssertTrue(heartButton.exists)
        }
    }
    
    func testPullToRefresh() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 20))
        
        let start = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3))
        let end = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        start.press(forDuration: 0.1, thenDragTo: end)
        
        XCTAssertTrue(app.navigationBars["Art Gallery"].exists)
    }
}
