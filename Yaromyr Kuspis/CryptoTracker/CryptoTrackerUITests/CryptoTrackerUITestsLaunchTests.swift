//
//  CryptoTrackerUITestsLaunchTests.swift
//  CryptoTrackerUITests
//
//  Created by Яромир-Олег Куспісь on 13.12.2025.
//

import XCTest

final class CryptoTrackerUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-UITest")
        app.launch()



        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
