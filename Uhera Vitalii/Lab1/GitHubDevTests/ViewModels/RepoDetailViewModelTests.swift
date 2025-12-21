//
//  RepoDetailViewModelTests.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

import XCTest

@testable import Lab1

@MainActor
final class RepoDetailViewModelTests: XCTestCase {

    func testOpenDeveloperProfileTriggersCoordinator() async {
        let repo = TestDataFactory.repo()
        let dev = TestDataFactory.developer()

        let coordinator = MockAppCoordinator()

        let sut = RepoDetailViewModel(
            repository: repo,
            developer: dev,
            coordinator: coordinator
        )

        sut.openDeveloperProfile()

        XCTAssertEqual(coordinator.openedDeveloper?.username, dev.username)
    }

    func testOpenDeveloperProfileDoesNothingWhenNil() async {
        let coordinator = MockAppCoordinator()

        let sut = RepoDetailViewModel(
            repository: .mock,
            developer: nil,
            coordinator: coordinator
        )

        sut.openDeveloperProfile()

        XCTAssertNil(coordinator.openedDeveloper)
    }
}
