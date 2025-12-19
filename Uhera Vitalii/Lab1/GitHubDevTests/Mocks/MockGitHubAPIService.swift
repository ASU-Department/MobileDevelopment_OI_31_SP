//
//  MockGitHubAPIService.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

import Foundation

@testable import Lab1

final class MockGitHubAPIService: GitHubAPIServiceProtocol {

    enum MockError: Error {
        case network
        case notFound
    }

    // MARK: - Configurable responses
    var userResult: Result<GitHubUserDTO, Error> = .success(
        GitHubUserDTO(
            id: 1,
            login: "octocat",
            avatarUrl: nil,
            name: "Octo Cat",
            bio: nil,
            followers: 10,
            following: 5,
            publicRepos: 3
        )
    )

    var reposResult: Result<[GitHubRepositoryDTO], Error> = .success([])

    var artificialDelay: UInt64 = 0

    // MARK: - API
    func fetchUser(username: String) async throws -> GitHubUserDTO {
        if artificialDelay > 0 {
            try await Task.sleep(nanoseconds: artificialDelay)
        }
        return try userResult.get()
    }

    func fetchRepositories(username: String) async throws
        -> [GitHubRepositoryDTO]
    {
        if artificialDelay > 0 {
            try await Task.sleep(nanoseconds: artificialDelay)
        }
        return try reposResult.get()
    }
}
