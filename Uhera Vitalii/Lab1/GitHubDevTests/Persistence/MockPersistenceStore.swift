//
//  MockPersistenceStore.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

import Foundation

@testable import Lab1

final class MockPersistenceStore: AnyPersistenceStore {

    private(set) var repositories: [CachedRepository] = []
    private(set) var developer: CachedUser? = nil
    private(set) var starredRepoIds: Set<Int> = []

    func save(repositories: [Repository], developer: DeveloperProfile) {
        self.repositories = repositories.map {
            CachedRepository(
                id: $0.id,
                name: $0.name,
                fullName: $0.fullName,
                stars: $0.stargazersCount,
                watchers: $0.watchersCount,
                issues: $0.openIssuesCount,
                language: $0.language,
                ownerLogin: $0.owner.login
            )
        }

        self.developer = CachedUser(
            id: developer.id,
            username: developer.username,
            avatarUrl: developer.avatarUrl,
            followers: developer.followers,
            following: developer.following
        )
    }

    func fetchRepos() -> [CachedRepository] {
        repositories
    }

    func fetchDev() -> CachedUser? {
        developer
    }

    func toggleStar(repoId: Int) {
        if self.starredRepoIds.contains(repoId) {
            self.starredRepoIds.remove(repoId)
        } else {
            self.starredRepoIds.insert(repoId)
        }
    }

    func fetchStarredRepoIds() -> Set<Int> {
        starredRepoIds
    }
}
