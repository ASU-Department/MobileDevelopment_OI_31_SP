import XCTest

extension XCTestCase {

    func launchForUITesting() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
        return app
    }

    func enterWorkoutName(_ text: String, app: XCUIApplication) {
        let field = app.textFields["workoutNameField"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()

        // очистити попереднє
        if let current = field.value as? String,
           !current.isEmpty,
           current != "Enter workout name or exercise" {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: current.count)
            field.typeText(deleteString)
        }

        field.typeText(text)

        // закрити клавіатуру
        if app.keyboards.element.exists {
            let returnKey = app.keyboards.buttons["Return"]
            if returnKey.exists { returnKey.tap() } else { app.tap() }
        }

        // дочекатися, що Save увімкнувся
        let save = app.buttons["saveWorkoutButton"]
        XCTAssertTrue(save.waitForExistence(timeout: 2))

        let start = Date()
        while Date().timeIntervalSince(start) < 3 {
            if save.isEnabled { return }
            RunLoop.current.run(until: Date().addingTimeInterval(0.05))
        }
        XCTFail("Save button is still disabled after entering workout name.")
    }

    func openSavedScreen(app: XCUIApplication) {
        let savedButton = app.buttons["Saved"]
        XCTAssertTrue(savedButton.waitForExistence(timeout: 5))
        savedButton.tap()

        XCTAssertTrue(app.tables["savedWorkoutsList"].waitForExistence(timeout: 5))
    }

    /// ✅ Надійний пошук рядка у Saved списку (як cell/button з label CONTAINS name)
    func findSavedWorkoutCell(app: XCUIApplication, name: String, timeout: TimeInterval = 5) -> XCUIElement {
        let table = app.tables["savedWorkoutsList"]
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        let pred = NSPredicate(format: "label CONTAINS %@", name)

        // 1) пробуємо без скролу
        var cell = table.cells.containing(pred).firstMatch
        if cell.exists { return cell }

        // 2) скролимо вниз кілька разів
        let start = Date()
        while Date().timeIntervalSince(start) < timeout {
            table.swipeUp()
            cell = table.cells.containing(pred).firstMatch
            if cell.exists { return cell }
        }

        return cell // повернемо firstMatch (exists=false) — тест впаде вище
    }

    func goBack(app: XCUIApplication) {
        // універсально: перша кнопка back в navigation bar
        let back = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(back.waitForExistence(timeout: 5))
        back.tap()
    }
    func savedListRoot(app: XCUIApplication) -> XCUIElement {
        // Якщо у тебе реально Table — добре.
        // Якщо ні — fallback на scrollViews/otherElements.
        let table = app.tables["savedWorkoutsList"]
        if table.exists { return table }

        let scroll = app.scrollViews["savedWorkoutsList"]
        if scroll.exists { return scroll }

        let other = app.otherElements["savedWorkoutsList"]
        if other.exists { return other }

        return app.tables.firstMatch
    }

    func savedListContains(app: XCUIApplication, name: String) -> Bool {
        let root = savedListRoot(app: app)

        let pred = NSPredicate(format: "label CONTAINS %@", name)

        // пробуємо як cell
        if root.cells.containing(pred).firstMatch.exists { return true }

        // пробуємо як button (бо у тебе рядок — Button)
        if root.buttons.containing(pred).firstMatch.exists { return true }

        // пробуємо як staticText
        if root.staticTexts.containing(pred).firstMatch.exists { return true }

        return false
    }

    func waitForSavedListContains(app: XCUIApplication, name: String, timeout: TimeInterval) -> Bool {
        let root = savedListRoot(app: app)
        let start = Date()

        while Date().timeIntervalSince(start) < timeout {
            if savedListContains(app: app, name: name) { return true }
            // якщо список довгий — трохи скролимо
            if root.exists { root.swipeDown() }
            RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        }
        return false
    }
}
