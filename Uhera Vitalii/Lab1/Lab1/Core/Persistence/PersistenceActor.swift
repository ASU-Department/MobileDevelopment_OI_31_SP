//
//  PersistenceActor.swift
//  Lab1
//
//  Created by UnseenHand on 17.12.2025.
//

import Foundation

actor PersistenceActor {

    private let store: AnyPersistenceStore

    init(store: AnyPersistenceStore = PersistenceStore.shared) {
        self.store = store
    }

    func save(
        repositories: [Repository],
        developer: DeveloperProfile
    ) async {
        await store.save(
            repositories: repositories,
            developer: developer
        )
    }

    func fetchRepositories() async -> [Repository] {
        let cached: [CachedRepository] = await store.fetchRepos()

        return cached.map {
            Repository(
                id: $0.id,
                name: $0.name,
                fullName: $0.fullName,
                description: nil,
                htmlUrl: nil,
                language: $0.language,
                stargazersCount: $0.stars,
                watchersCount: $0.watchers,
                forksCount: 0,
                openIssuesCount: $0.issues,
                defaultBranch: "main",
                createdAt: Date(),
                updatedAt: Date(),
                owner: RepositoryOwner(
                    login: $0.ownerLogin,
                    avatarUrl: nil,
                    location: nil
                )
            )
        }
    }

    func fetchDeveloper() async -> DeveloperProfile? {
        guard let cached = await store.fetchDev() else { return nil }

        return DeveloperProfile(
            id: cached.id,
            username: cached.username,
            name: nil,
            bio: nil,
            avatarUrl: cached.avatarUrl,
            followers: cached.followers,
            following: cached.following,
            publicRepos: 0
        )
    }

    func toggleStar(repoId: Int) async {
        await store.toggleStar(repoId: repoId)
    }

    func fetchStarredRepoIds() async -> Set<Int> {
        await store.fetchStarredRepoIds()
    }

}
