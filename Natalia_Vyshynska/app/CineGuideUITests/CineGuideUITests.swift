import XCTest

final class CineGuideUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    func testToggleFavoriteInList() throws {
        let firstHeartButton = app.buttons["heartButton"].firstMatch
        XCTAssertTrue(firstHeartButton.waitForExistence(timeout: 10))
        
        firstHeartButton.tap()
        
        let filledHeart = app.buttons["heartFillButton"].firstMatch
        XCTAssertTrue(filledHeart.exists)
        
        // Тап знову – має повернутися порожнє сердечко
        filledHeart.tap()
        XCTAssertTrue(firstHeartButton.exists)
    }
    
    func testAddFavoriteInDetail() throws {
        let firstMovieCell = app.staticTexts["movieTitle"].firstMatch
        XCTAssertTrue(firstMovieCell.waitForExistence(timeout: 10))
        
        firstMovieCell.tap()
        
        let addButton = app.buttons["Додати в обране"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        
        addButton.tap()
        
        let addedButton = app.buttons["В обраних"]
        XCTAssertTrue(addedButton.exists)
    }
}
