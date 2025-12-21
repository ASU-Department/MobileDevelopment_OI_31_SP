import XCTest

class PokedexterUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSearchFlow() throws {
        let searchBar = app.textFields["Search Pokémon..."]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5))
        
        searchBar.tap()
        searchBar.typeText("Pik")
        
        let list = app.tables["pokemon_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        searchBar.typeText(XCUIKeyboardKey.delete.rawValue)
        searchBar.typeText(XCUIKeyboardKey.delete.rawValue)
        searchBar.typeText(XCUIKeyboardKey.delete.rawValue)
    }
    
    func testPullToRefresh() {
        let list = app.tables["pokemon_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        let startCoord = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.0))
        let endCoord = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6))
        startCoord.press(forDuration: 0.1, thenDragTo: endCoord)
        
        XCTAssertTrue(list.exists)
    }
    
    func testFilterFavoritesToggle() {
        let toggle = app.switches["filter_favorites_toggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 5))
        
        toggle.tap()
        
        let list = app.tables["pokemon_list"]
        XCTAssertTrue(list.exists)
        
        toggle.tap()
    }
    
    func testNavigationAndFavorite() throws {
        let list = app.tables["pokemon_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        let firstCell = list.cells.firstMatch
        if firstCell.exists {
            firstCell.tap()
            
            let favButton = app.buttons["favorite_button"]
            XCTAssertTrue(favButton.waitForExistence(timeout: 2))
            
            favButton.tap()
            
            app.navigationBars.buttons.firstMatch.tap()
        }
    }
}
