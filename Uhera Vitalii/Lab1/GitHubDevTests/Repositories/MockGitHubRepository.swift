//
//  MockGitHubRepository.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

import Foundation

@testable import Lab1

final class MockGitHubRepository: GitHubRepositoryProtocol {

    private let repos: [Repository]
    private let developer: DeveloperProfile
    private var starred: Set<Int>
    private let shouldFail: Bool

    init(
        repositories: [Repository] = [.mock],
        developer: DeveloperProfile = .mock,
        starredRepoIds: Set<Int> = [],
        shouldFail: Bool = false
    ) {
        self.repos = repositories
        self.developer = developer
        self.starred = starredRepoIds
        self.shouldFail = shouldFail
    }

    func loadRepositories(username: String) async throws -> [Repository] {
        if shouldFail { throw URLError(.notConnectedToInternet) }
        return repos
    }

    func loadUser(username: String) async throws -> DeveloperProfile {
        if shouldFail { throw URLError(.notConnectedToInternet) }
        return developer
    }

    func save(repositories: [Repository], developer: DeveloperProfile) async {}

    func loadCachedRepositories() async -> [Repository] { repos }
    func loadCachedDeveloper() async -> DeveloperProfile? { developer }

    func toggleStar(repoId: Int) async {
        if starred.contains(repoId) {
            starred.remove(repoId)
        } else {
            starred.insert(repoId)
        }
    }
    func loadStarredRepoIds() async -> Set<Int> { starred }
}
