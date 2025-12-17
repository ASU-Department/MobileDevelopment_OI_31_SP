//
//  GitHubRepository.swift
//  Lab1
//
//  Created by UnseenHand on 17.12.2025.
//

import Foundation

final class GitHubRepository: GitHubRepositoryProtocol {

    private let api: GitHubAPIServiceProtocol
    private let persistenceActor: PersistenceActor

    init(
        api: GitHubAPIServiceProtocol,
        persistenceActor: PersistenceActor
    ) {
        self.api = api
        self.persistenceActor = persistenceActor
    }

    func loadUser(username: String) async throws -> DeveloperProfile {
        let dto = try await api.fetchUser(username: username)
        return DeveloperProfile(dto: dto)
    }

    func loadRepositories(username: String) async throws -> [Repository] {
        let dtos = try await api.fetchRepositories(username: username)
        return dtos.map { Repository(dto: $0) }
    }

    func loadCachedRepositories() async -> [Repository] {
        await persistenceActor.fetchRepositories()
    }

    func loadCachedDeveloper() async -> DeveloperProfile? {
        await persistenceActor.fetchDeveloper()
    }

    func save(
        repositories: [Repository],
        developer: DeveloperProfile
    ) async {
        await persistenceActor.save(
            repositories: repositories,
            developer: developer
        )
    }
}
