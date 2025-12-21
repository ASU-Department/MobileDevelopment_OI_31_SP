//
//  GitHubMappings.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import Foundation

extension Repository {
    init(dto: GitHubRepositoryDTO) {
        self.id = dto.id
        self.name = dto.name
        self.fullName = dto.fullName
        self.description = dto.description
        self.htmlUrl = URL(string: "https://github.com/\(dto.fullName)")
        self.language = dto.language
        self.stargazersCount = dto.stargazersCount
        self.watchersCount = dto.watchersCount
        self.forksCount = dto.forksCount
        self.openIssuesCount = dto.openIssuesCount
        self.defaultBranch = "main"
        self.createdAt = Date()
        self.updatedAt = Date()
        self.owner = RepositoryOwner(
            login: dto.owner.login,
            avatarUrl: dto.owner.avatarUrl,
            location: nil
        )
    }
}

extension DeveloperProfile {
    init(dto: GitHubUserDTO) {
        self.id = dto.id
        self.username = dto.login
        self.name = dto.name
        self.bio = dto.bio
        self.avatarUrl = dto.avatarUrl
        self.followers = dto.followers
        self.following = dto.following
        self.publicRepos = dto.publicRepos
        self.repos = []
    }
}
