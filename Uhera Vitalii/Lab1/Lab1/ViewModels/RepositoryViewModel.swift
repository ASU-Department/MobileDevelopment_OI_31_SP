//
//  RepositoryViewModel.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//

import Combine
import Foundation

final class RepositoryViewModel: ObservableObject {
    @Published var showAdvancedFilters = false

    @Published var useSliderMode = true  // switch between slider + manual
    @Published var minStars: Double = 0

    @Published var languageFilter: String = "Any"
    @Published var showOnlyStarred = false
    @Published var showOnlyWithIssues = false
    @Published var sortMode: RepoSortMode = .stars

    @Published var searchText: String = ""
    @Published var minWatchers: Double = 0
    @Published var minIssues: Double = 0

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
        let filtered = repositories.filter { repo in
            let matchesSearch =
                searchText.isEmpty
                || repo.name.localizedCaseInsensitiveContains(searchText)
                || repo.fullName.localizedCaseInsensitiveContains(searchText)
                || (repo.language?.localizedCaseInsensitiveContains(searchText)
                    ?? false)
            let matchesStar =
                !showOnlyStarred || starredRepoIds.contains(repo.id)
            let matchesWatchers = repo.watchersCount >= Int(minWatchers)
            let matchesIssues = repo.openIssuesCount >= Int(minIssues)
            return matchesSearch && matchesStar && matchesWatchers
                && matchesIssues
        }

        switch sortMode {
        case .stars:
            return filtered.sorted { $0.stargazersCount < $1.stargazersCount }
        case .issues:
            return filtered.sorted { $0.openIssuesCount < $1.openIssuesCount }
        case .alphabet:
            return filtered.sorted { $0.name < $1.name }
        }
    }

    func developer(for ownerLogin: String) -> DeveloperProfile? {
        developers.first(where: { $0.username == ownerLogin })
    }
}
