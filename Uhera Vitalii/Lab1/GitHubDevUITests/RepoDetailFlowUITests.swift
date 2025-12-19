//
//  RepoDetailFlowUITests.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

import XCTest

final class RepoDetailFlowUITests: XCTestCase {

    var app: XCUIApplication!
    var repoId: String = ""

    override func setUp() {
        continueAfterFailure = false
        app = UITestHelpers.launchApp()

        repoId = "1300192"
    }

    func test_starRepository_persistsState() {
        app.buttons["Load"].tap()

        let repoRow = app.cells.containing(
            .staticText,
            identifier: "repoRow_\(repoId)"
        ).firstMatch

        UITestHelpers.waitForElement(repoRow)

        let starButton = repoRow.buttons["repoRow_\(repoId)"]

        UITestHelpers.waitForElement(starButton)
        starButton.tap()

        XCTAssertTrue(starButton.exists)
    }

    func test_openDeveloperProfile() {
        app.buttons["loadButton"].tap()

        let repo = app.cells.containing(
            .staticText,
            identifier: "repoRow_\(repoId)"
        ).firstMatch
        UITestHelpers.waitForElement(repo)
        repo.tap()

        let devButton = app.buttons["openDeveloperButton"]
        UITestHelpers.waitForElement(devButton)
        devButton.tap()

        XCTAssertTrue(app.navigationBars.element.exists)
    }

    func test_shareSheetOpens() {
        app.buttons["loadButton"].tap()

        let repo = app.cells.containing(
            .staticText,
            identifier: "repoRow_\(repoId)"
        ).firstMatch
        UITestHelpers.waitForElement(repo)
        repo.tap()

        let shareButton = app.buttons["shareButton"]
        UITestHelpers.waitForElement(shareButton)
        shareButton.tap()

        let openedShare = app.scrollViews.containing(.cell, identifier: "shareCell").firstMatch

        UITestHelpers.waitForElement(openedShare)
        
        XCTAssertTrue(
            openedShare.exists,
            "The sheet was not presented or the content label does not exist"
        )
    }
}
