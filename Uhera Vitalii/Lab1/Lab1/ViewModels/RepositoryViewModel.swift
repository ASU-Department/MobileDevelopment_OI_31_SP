//
//  RepositoryViewModel.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import Foundation
import Combine

final class RepositoryViewModel: ObservableObject {
    // UI state — make them @Published so the view updates
    @Published var searchText: String = ""
    @Published var showStarredOnly: Bool = false
    @Published var minWatchers: Int = 0
    @Published var minIssues: Int = 0

    // Data
    @Published var repositories: [Repository] = FakeRepositoryData.sample()

    // store only the IDs of starred repos (local session favorites)
    @Published private(set) var starredRepoIds: Set<Int> = []

    // MARK: - Helpers

    func isStarred(_ repo: Repository) -> Bool {
        starredRepoIds.contains(repo.id)
    }

    func toggleStar(_ repo: Repository) {
        if starredRepoIds.contains(repo.id) {
            starredRepoIds.remove(repo.id)
        } else {
            starredRepoIds.insert(repo.id)
        }
    }

    // Computed filtered list depends on @Published properties above
    var filteredRepositories: [Repository] {
        repositories.filter { repo in
            let matchesSearch = searchText.isEmpty ||
                repo.name.localizedCaseInsensitiveContains(searchText)

            let matchesStarFilter = !showStarredOnly || starredRepoIds.contains(repo.id)

            let matchesWatchers = repo.watchersCount >= minWatchers
            let matchesIssues = repo.openIssuesCount >= minIssues

            return matchesSearch && matchesStarFilter && matchesWatchers && matchesIssues
        }
    }
}
