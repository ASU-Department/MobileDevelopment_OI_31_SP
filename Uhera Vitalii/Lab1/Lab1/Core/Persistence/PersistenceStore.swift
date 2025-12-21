//
//  PersistenceStore.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceStore : AnyPersistenceStore {
    static let shared = PersistenceStore()

    private let container: ModelContainer

    init() {
        container = try! ModelContainer(
            for: CachedRepository.self,
            CachedUser.self,
            CachedStar.self
        )
    }

    func save(repositories: [Repository], developer: DeveloperProfile) {
        let context = container.mainContext

        repositories.forEach {
            context.insert(
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
            )
        }

        context.insert(
            CachedUser(
                id: developer.id,
                username: developer.username,
                avatarUrl: developer.avatarUrl,
                followers: developer.followers,
                following: developer.following
            )
        )
    }

    func toggleStar(repoId: Int) {
        let context = container.mainContext

        let descriptor = FetchDescriptor<CachedStar>(
            predicate: #Predicate { $0.repoId == repoId }
        )

        if let existing = try? context.fetch(descriptor).first {
            context.delete(existing)
        } else {
            context.insert(CachedStar(repoId: repoId))
        }
    }

    func fetchRepos() -> [CachedRepository] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<CachedRepository>()
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchDev() -> CachedUser? {
        let context = container.mainContext
        let descriptor = FetchDescriptor<CachedUser>()
        return (try? context.fetch(descriptor).first)
    }

    func fetchStarredRepoIds() -> Set<Int> {
        let context = container.mainContext
        let descriptor = FetchDescriptor<CachedStar>()
        let stars = (try? context.fetch(descriptor)) ?? []
        return Set(stars.map { $0.repoId })
    }
}

protocol AnyPersistenceStore {
    func save(repositories: [Repository], developer: DeveloperProfile)
    func fetchRepos() -> [CachedRepository]
    func fetchDev() -> CachedUser?
    func toggleStar(repoId: Int)
    func fetchStarredRepoIds() -> Set<Int>
}
