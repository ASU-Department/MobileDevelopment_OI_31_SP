//
//  RepositoryViewModel.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import Foundation
import Combine

final class RepositoryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var showStarredOnly: Bool = false
    @Published var minWatchers: Int = 0
    @Published var minIssues: Int = 0

    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var developers: [DeveloperProfile] = []

    @Published private(set) var starredRepoIds: Set<Int> = []

    private let service: RepositoryServiceProtocol

    init(service: RepositoryServiceProtocol = MockRepositoryService.shared) {
        self.service = service
    }

    func load() async {
        let repos = await service.fetchRepositories()
        let devs = await service.fetchDevelopers()
        self.repositories = repos
        self.developers = devs
    }

    func toggleStar(_ repo: Repository) {
        if starredRepoIds.contains(repo.id) {
            starredRepoIds.remove(repo.id)
        } else {
            starredRepoIds.insert(repo.id)
        }
    }

    func isStarred(_ repo: Repository) -> Bool {
        starredRepoIds.contains(repo.id)
    }

    var filteredRepositories: [Repository] {
        repositories.filter { repo in
            let matchesSearch =
                searchText.isEmpty ||
                repo.name.localizedCaseInsensitiveContains(searchText) ||
                repo.fullName.localizedCaseInsensitiveContains(searchText) ||
                (repo.language?.localizedCaseInsensitiveContains(searchText) ?? false)
            let matchesStar = !showStarredOnly || starredRepoIds.contains(repo.id)
            let matchesWatchers = repo.watchersCount >= minWatchers
            let matchesIssues = repo.openIssuesCount >= minIssues
            return matchesSearch && matchesStar && matchesWatchers && matchesIssues
        }
    }

    func developer(for ownerLogin: String) -> DeveloperProfile? {
        developers.first(where: { $0.username == ownerLogin })
    }
}
