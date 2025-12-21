//
//  XCUIElement+Clear.swift
//  GitHubDevUITests
//
//  Created by UnseenHand on 19.12.2025.
//

import XCTest

extension XCUIElement {
    func clearAndTypeText(_ text: String) {
        tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: value.debugDescription.count)
        typeText(deleteString)
        typeText(text)
    }
}

