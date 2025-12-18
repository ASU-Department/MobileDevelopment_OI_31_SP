import XCTest

final class LabWork1UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // Тест 1: Додавання акції через UI
    func testAddStockFlow() throws {
        let app = XCUIApplication()
        app.launch()

        // 1. Знайти кнопку "+"
        let addButton = app.buttons["plus"]
        if addButton.exists {
            addButton.tap()
            
            // 2. Ввести текст
            let textField = app.textFields["Symbol (e.g. NVDA)"]
            if textField.waitForExistence(timeout: 2) {
                textField.tap()
                textField.typeText("META") // Вводимо META
                
                // 3. Натиснути Add
                app.buttons["Add"].tap()
                
                // 4. Перевірити чи з'явилось у списку
                let newStockText = app.staticTexts["META"]
                XCTAssertTrue(newStockText.waitForExistence(timeout: 5))
            }
        }
    }
    
    // Тест 2: Навігація на деталі
    func testNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Беремо перший елемент списку (якийсь має бути)
        let firstCell = app.cells.firstMatch
        if firstCell.waitForExistence(timeout: 5) {
            firstCell.tap()
            
            // Перевіряємо заголовок "Analysis"
            XCTAssertTrue(app.staticTexts["Analysis"].waitForExistence(timeout: 2))
        }
    }
}
