//
//  RepoSearchViewModel.swift
//  Lab1
//
//  Created by UnseenHand on 17.12.2025.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class RepoSearchViewModel: ObservableObject {
    private let repository: GitHubRepositoryProtocol
    private let coordinator: AppCoordinating

    @AppStorage("lastUsername")
    private var storedUsername = "octocat"

    @AppStorage("useSliderMode")
    private var storedUseSliderMode = true

    @AppStorage("sortMode")
    private var storedSortModeRaw = RepoSortMode.stars.rawValue

    @Published var username: String = ""
    @Published var isLoading = false
    @Published var isOffline = false
    @Published var errorMessage: String?

    @Published var searchText = ""
    @Published var useSliderMode: Bool = true
    @Published var sortMode: RepoSortMode = .stars
    @Published var showAdvancedFilters = false

    @Published var minStars: Double = 0
    @Published var minIssues: Double = 0
    @Published var minWatchers: Double = 0

    @Published var showOnlyStarred = false
    @Published var showOnlyWithIssues = false

    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var developer: DeveloperProfile?
    @Published private(set) var starredRepoIds: Set<Int> = []

    init(
        repository: GitHubRepositoryProtocol,
        coordinator: AppCoordinating
    ) {
        self.repository = repository
        self.coordinator = coordinator

        self.username = ""
        
        let initialUsername = storedUsername
        let initialUseSliderMode = storedUseSliderMode
        let initialSortMode =
            RepoSortMode(rawValue: storedSortModeRaw) ?? .stars

        self.username = initialUsername
        self.useSliderMode = initialUseSliderMode
        self.sortMode = initialSortMode
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        storedUsername = username
        storedUseSliderMode = useSliderMode
        storedSortModeRaw = sortMode.rawValue

        do {
            let dev = try await repository.loadUser(username: username)
            let repos = try await repository.loadRepositories(
                username: username
            )
            let starred = await repository.loadStarredRepoIds()

            developer = dev
            repositories = repos
            starredRepoIds = starred

            await repository.save(
                repositories: repos,
                developer: dev
            )

            isOffline = false

        } catch {
            isOffline = true
            repositories = await repository.loadCachedRepositories()
            developer = await repository.loadCachedDeveloper()
            starredRepoIds = await repository.loadStarredRepoIds()
            errorMessage = "Offline — showing cached data"
        }

        isLoading = false
    }

    var filteredRepositories: [Repository] {
        repositories
            .filter(matchesSearch)
            .filter(matchesStars)
            .filter(matchesIssues)
            .filter(matchesSliderFilters)
            .sorted(by: sortRule)
    }

    private func matchesSearch(_ repo: Repository) -> Bool {
        searchText.isEmpty
            || repo.name.localizedCaseInsensitiveContains(searchText)
            || repo.fullName.localizedCaseInsensitiveContains(searchText)
    }

    private func matchesStars(_ repo: Repository) -> Bool {
        !showOnlyStarred || starredRepoIds.contains(repo.id)
    }

    private func matchesIssues(_ repo: Repository) -> Bool {
        !showOnlyWithIssues || repo.openIssuesCount > 0
    }

    private func matchesSliderFilters(_ repo: Repository) -> Bool {
        repo.stargazersCount >= Int(minStars)
            && repo.openIssuesCount >= Int(minIssues)
            && repo.watchersCount >= Int(minWatchers)
    }

    private func sortRule(_ lhs: Repository, _ rhs: Repository) -> Bool {
        switch sortMode {
        case .stars:
            lhs.stargazersCount > rhs.stargazersCount
        case .issues:
            lhs.openIssuesCount > rhs.openIssuesCount
        case .alphabet:
            lhs.name.localizedCompare(rhs.name) == .orderedAscending
        }
    }

    func openDetails(_ repo: Repository) {
        coordinator.openRepository(repo, developer: developer)
    }

    func toggleStar(_ repo: Repository) {
        Task {
            await repository.toggleStar(repoId: repo.id)
            starredRepoIds = await repository.loadStarredRepoIds()
        }
    }

    func isStarred(_ repo: Repository) -> Bool {
        starredRepoIds.contains(repo.id)
    }
}
