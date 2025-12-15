//
//  FakeRepos.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//

import Foundation

struct FakeRepositoryData {
    static func sample() -> [Repository] {
        [
            Repository(
                id: 1,
                name: "SwiftAlgorithms",
                fullName: "apple/swift-algorithms",
                description: "Common algorithms for Swift.",
                language: "Swift",
                stargazersCount: 3200,
                watchersCount: 120,
                openIssuesCount: 12,
                forksCount: 210,
                htmlURL: "https://github.com/apple/swift-algorithms",
                defaultBranch: "main",
                createdAt: Date(),
                updatedAt: Date(),
                owner: RepositoryOwner(login: "apple", avatarURL: "")
            ),
            Repository(
                id: 2,
                name: "TensorFlow",
                fullName: "google/tensorflow",
                description: "ML framework by Google.",
                language: "C++",
                stargazersCount: 180000,
                watchersCount: 5000,
                openIssuesCount: 2000,
                forksCount: 88000,
                htmlURL: "https://github.com/google/tensorflow",
                defaultBranch: "master",
                createdAt: Date(),
                updatedAt: Date(),
                owner: RepositoryOwner(login: "google", avatarURL: "")
            )
        ]
    }
}

