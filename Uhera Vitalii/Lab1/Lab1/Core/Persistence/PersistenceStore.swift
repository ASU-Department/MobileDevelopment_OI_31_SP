//
//  PersistenceStore.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import SwiftData

final class PersistenceStore {
    static let shared = PersistenceStore()

    private let container: ModelContainer

    init() {
        container = try! ModelContainer(
            for: CachedRepository.self,
            CachedUser.self
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
}
