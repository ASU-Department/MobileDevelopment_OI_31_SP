//
//  AsyncTestHelpers.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//


import XCTest

enum AsyncTestHelpers {

    static func assertEventually(
        timeout: TimeInterval = 1.0,
        pollInterval: TimeInterval = 0.05,
        _ condition: @escaping () -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) async {
        let deadline = Date().addingTimeInterval(timeout)

        while Date() < deadline {
            if condition() { return }
            try? await Task.sleep(nanoseconds: UInt64(pollInterval * 1_000_000_000))
        }

        XCTFail("Condition not met within timeout", file: file, line: line)
    }
}
