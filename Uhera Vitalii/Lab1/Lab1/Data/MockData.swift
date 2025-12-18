//
//  MockData.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//


import Foundation

enum MockData {
    static func sampleRepos() -> [Repository] {
        let now = Date()
        let owner1 = RepositoryOwner(login: "apple", avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145"), location: "Cupertino, CA")
        let owner2 = RepositoryOwner(login: "microsoft", avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/6154722"), location: "Redmond, WA")
        let owner3 = RepositoryOwner(login: "facebook", avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/69631"), location: "Menlo Park, CA")

        return [
            Repository(
                id: 1, name: "swift", fullName: "apple/swift",
                description: "The Swift Programming Language", htmlUrl: URL(string: "https://github.com/apple/swift"),
                language: "C++", stargazersCount: 65000, watchersCount: 5000, forksCount: 10000, openIssuesCount: 850,
                defaultBranch: "main", createdAt: now, updatedAt: now, owner: owner1
            ),
            Repository(
                id: 2, name: "vscode", fullName: "microsoft/vscode",
                description: "Visual Studio Code", htmlUrl: URL(string: "https://github.com/microsoft/vscode"),
                language: "TypeScript", stargazersCount: 150000, watchersCount: 8000, forksCount: 25000, openIssuesCount: 1800,
                defaultBranch: "main", createdAt: now, updatedAt: now, owner: owner2
            ),
            Repository(
                id: 3, name: "react", fullName: "facebook/react",
                description: "A JavaScript library for building UIs", htmlUrl: URL(string: "https://github.com/facebook/react"),
                language: "JavaScript", stargazersCount: 210000, watchersCount: 12000, forksCount: 45000, openIssuesCount: 900,
                defaultBranch: "main", createdAt: now, updatedAt: now, owner: owner3
            )
        ]
    }

    static func sampleDevelopers() -> [DeveloperProfile] {
        let repos = sampleRepos()
        let dev1 = DeveloperProfile(username: "apple", name: "Apple", bio: "Developer of Swift", avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145"), followers: 100000, following: 0, publicRepos: 500, repos: repos.filter { $0.owner.login == "apple" })
        let dev2 = DeveloperProfile(username: "microsoft", name: "Microsoft", bio: "Tools and platforms", avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/6154722"), followers: 90000, following: 10, publicRepos: 600, repos: repos.filter { $0.owner.login == "microsoft" })
        let dev3 = DeveloperProfile(username: "facebook", name: "Facebook", bio: "Open-source web libs", avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/69631"), followers: 110000, following: 2, publicRepos: 700, repos: repos.filter { $0.owner.login == "facebook" })

        return [dev1, dev2, dev3]
    }
}
