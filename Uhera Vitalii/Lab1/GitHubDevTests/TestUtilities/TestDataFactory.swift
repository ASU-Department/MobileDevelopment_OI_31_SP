//
//  TestDataFactory.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//

@testable import Lab1
import Foundation

enum TestDataFactory {

    static func repo(
        id: Int = 1,
        name: String = "Repo",
        stars: Int = 0,
        issues: Int = 0
    ) -> Repository {
        Repository(
            id: id,
            name: name,
            fullName: "user/\(name)",
            description: nil,
            htmlUrl: nil,
            language: "Swift",
            stargazersCount: stars,
            watchersCount: 0,
            forksCount: 0,
            openIssuesCount: issues,
            defaultBranch: "main",
            createdAt: Date(),
            updatedAt: Date(),
            owner: RepositoryOwner(
                login: "user",
                avatarUrl: nil,
                location: nil
            )
        )
    }

    static func repositories() -> [Repository] {
        [
            repo(id: 1, name: "A", stars: 10),
            repo(id: 2, name: "B", stars: 1),
        ]
    }

    static func developer(username: String = "octocat") -> DeveloperProfile {
        DeveloperProfile(
            id: 1,
            username: username,
            name: "Octo",
            bio: nil,
            avatarUrl: nil,
            followers: 10,
            following: 5,
            publicRepos: 2
        )
    }
}
