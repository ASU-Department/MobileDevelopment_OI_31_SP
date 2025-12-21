//
//  RepoSearchFlowUITests.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//


import XCTest

final class RepoSearchFlowUITests: XCTestCase {

    var app: XCUIApplication!
    var repoId: String = ""

    override func setUp() {
        continueAfterFailure = false
        app = UITestHelpers.launchApp()
        
        repoId = "1300192"
    }

    func test_loadRepositories_andFilterResults() {
        let usernameField = app.textFields["usernameField"]
        let loadButton = app.buttons["loadButton"]

        UITestHelpers.waitForElement(usernameField)
        usernameField.tap()
        usernameField.clearAndTypeText("octocat")

        loadButton.tap()

        let firstRepo = app.cells.containing(.staticText, identifier: "repoRow_\(repoId)").firstMatch
        UITestHelpers.waitForElement(firstRepo)

        // Apply search filter
        let searchBar = app.searchFields.firstMatch
        UITestHelpers.waitForElement(searchBar)
        searchBar.tap()
        searchBar.typeText("hello")

        XCTAssertTrue(!firstRepo.exists)
    }

    func test_navigateToRepoDetail() {
        let loadButton = app.buttons["loadButton"]
        loadButton.tap()

        let repo = app.cells.containing(.staticText, identifier: "repoRow_\(repoId)").firstMatch
        UITestHelpers.waitForElement(repo)

        repo.tap()

        let title = app.staticTexts["repoTitle"]
        UITestHelpers.waitForElement(title)

        XCTAssertTrue(title.exists)
    }
}

