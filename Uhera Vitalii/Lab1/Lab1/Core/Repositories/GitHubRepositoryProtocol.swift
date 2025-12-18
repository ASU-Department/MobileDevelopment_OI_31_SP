//
//  GitHubRepositoryProtocol.swift
//  Lab1
//
//  Created by UnseenHand on 17.12.2025.
//

import Foundation

protocol GitHubRepositoryProtocol {
    func loadUser(username: String) async throws -> DeveloperProfile
    func loadRepositories(username: String) async throws -> [Repository]
    func loadCachedRepositories() async -> [Repository]
    func loadCachedDeveloper() async -> DeveloperProfile?
    func save(repositories: [Repository], developer: DeveloperProfile) async
    func toggleStar(repoId: Int) async
    func loadStarredRepoIds() async -> Set<Int>
}
