//
//  RepositoryMock.swift
//  GitHubDevTests
//
//  Created by UnseenHand on 19.12.2025.
//

import Foundation

@testable import Lab1

extension GitHubRepositoryDTO {

    static var mock: GitHubRepositoryDTO {
        GitHubRepositoryDTO(
            id: 1,
            name: "MockRepo",
            fullName: "octocat/MockRepo",
            description: "Mock repository description",
            language: "Swift",
            stargazersCount: 42,
            watchersCount: 10,
            forksCount: 3,
            openIssuesCount: 1,
            topics: [],
            owner: GitHubRepositoryDTO.OwnerDTO(
                login: "octocat",
                avatarUrl: nil
            )
        )
    }

    static func mock(id: Int) -> GitHubRepositoryDTO {
        var repo = mock
        repo = GitHubRepositoryDTO(
            id: id,
            name: "MockRepo\(id)",
            fullName: "octocat/MockRepo\(id)",
            description: mock.description,
            language: mock.language,
            stargazersCount: mock.stargazersCount,
            watchersCount: mock.watchersCount,
            forksCount: mock.forksCount,
            openIssuesCount: mock.openIssuesCount,
            topics: mock.topics,
            owner: mock.owner
        )
        return repo
    }
}

extension GitHubUserDTO {

    static var mock: GitHubUserDTO {
        GitHubUserDTO(
            id: 99,
            login: "octocat",
            avatarUrl: URL(
                string: "https://github.com/images/error/octocat_happy.gif"
            ),
            name: "The Octocat",
            bio: "Mock developer profile",
            followers: 100,
            following: 5,
            publicRepos: 10
        )
    }
}

extension Repository {
    static var mock: Repository {
        Repository(
            id: 1,
            name: "MockRepo",
            fullName: "octocat/MockRepo",
            description: "Mock repository description",
            htmlUrl: URL(string: "https://github.com/octocat/MockRepo"),
            language: "Swift",
            stargazersCount: 42,
            watchersCount: 10,
            forksCount: 3,
            openIssuesCount: 1,
            defaultBranch: "main",
            createdAt: Date(),
            updatedAt: Date(),
            owner: RepositoryOwner(
                login: "octocat",
                avatarUrl: nil,
                location: nil
            )
        )
    }

    static func mock(id: Int) -> Repository {
        var repo = mock
        repo = Repository(
            id: id,
            name: "MockRepo\(id)",
            fullName: "octocat/MockRepo\(id)",
            description: mock.description,
            htmlUrl: mock.htmlUrl,
            language: mock.language,
            stargazersCount: mock.stargazersCount,
            watchersCount: mock.watchersCount,
            forksCount: mock.forksCount,
            openIssuesCount: mock.openIssuesCount,
            defaultBranch: mock.defaultBranch,
            createdAt: mock.createdAt,
            updatedAt: mock.updatedAt,
            owner: mock.owner
        )
        return repo
    }
}

extension DeveloperProfile {

    static var mock: DeveloperProfile {
        DeveloperProfile(
            id: 99,
            username: "octocat",
            name: "The Octocat",
            bio: "Mock developer profile",
            avatarUrl: URL(
                string: "https://github.com/images/error/octocat_happy.gif"
            ),
            followers: 100,
            following: 5,
            publicRepos: 10
        )
    }
}
