//
//  RepositoryServiceProtocol.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//

import Foundation

protocol RepositoryServiceProtocol {
    func fetchRepositories() async -> [Repository]
    func fetchDevelopers() async -> [DeveloperProfile]
}

final class MockRepositoryService: RepositoryServiceProtocol {
    static let shared = MockRepositoryService()

    private var repos: [Repository] = []
    private var developers: [DeveloperProfile] = []

    private init() {
        repos = MockData.sampleRepos()
        developers = MockData.sampleDevelopers()
    }

    func seed(_ repos: [Repository], developers: [DeveloperProfile]) {
        self.repos = repos
        self.developers = developers
    }

    func fetchRepositories() async -> [Repository] {
        try? await Task.sleep(nanoseconds: 100_000_000)
        return repos
    }

    func fetchDevelopers() async -> [DeveloperProfile] {
        try? await Task.sleep(nanoseconds: 80_000_000)
        return developers
    }
}
