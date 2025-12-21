//
//  MockAppCoordinator.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

@testable import Lab1

final class MockAppCoordinator: AppCoordinating {

    private(set) var openedRepository: Repository?
    private(set) var openedDeveloper: DeveloperProfile?

    func openRepository(
        _ repo: Repository,
        developer: DeveloperProfile?
    ) {
        openedRepository = repo
    }

    func openDeveloper(_ developer: DeveloperProfile) {
        openedDeveloper = developer
    }
}
