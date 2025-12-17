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
    // MARK: - Dependencies
    private let repository: GitHubRepositoryProtocol
    private let coordinator: AppCoordinator

    // MARK: - Persisted Settings
    @AppStorage("lastUsername") private var storedUsername = "octocat"
    @AppStorage("useSliderMode") private var storedUseSliderMode = true
    @AppStorage("sortMode") private var storedSortModeRaw = RepoSortMode.stars
        .rawValue

    // MARK: - UI State
    @Published var username: String = "octocat"
    @Published var isLoading = false
    @Published var isOffline = false
    @Published var errorMessage: String?

    // Filters
    @Published var searchText = ""
    @Published var useSliderMode: Bool = true
    @Published var sortMode: RepoSortMode = .stars
    @Published var showAdvancedFilters = false

    @Published var minStars: Double = 0
    @Published var minIssues: Double = 0
    @Published var minWatchers: Double = 0
    @Published var showOnlyStarred = false
    @Published var showOnlyWithIssues = false

    // Data
    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var developer: DeveloperProfile?
    private var starredRepoIds: Set<Int> = []

    init(
        repository: GitHubRepositoryProtocol,
        coordinator: AppCoordinator
    ) {
        self.repository = repository
        self.coordinator = coordinator

        self.username = storedUsername
        self.useSliderMode = storedUseSliderMode
        self.sortMode = RepoSortMode(rawValue: storedSortModeRaw) ?? .stars
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let dev = try await repository.loadUser(username: username)
            let repos = try await repository.loadRepositories(
                username: username
            )

            self.developer = dev
            self.repositories = repos

            await repository.save(
                repositories: repos,
                developer: dev
            )

            isOffline = false

        } catch {
            isOffline = true
            repositories = await repository.loadCachedRepositories()
            developer = await repository.loadCachedDeveloper()
            errorMessage = "Offline — showing cached data"
        }

        isLoading = false
    }

    var filteredRepositories: [Repository] {
        let filtered = repositories.filter { repo in
            searchText.isEmpty
                || repo.name.localizedCaseInsensitiveContains(searchText)
                || repo.fullName.localizedCaseInsensitiveContains(searchText)
        }

        switch sortMode {
        case .stars:
            return filtered.sorted { $0.stargazersCount > $1.stargazersCount }
        case .issues:
            return filtered.sorted { $0.openIssuesCount > $1.openIssuesCount }
        case .alphabet:
            return filtered.sorted { $0.name < $1.name }
        }
    }

    func openDetails(_ repo: Repository) {
        coordinator.openRepository(repo, developer: developer)
    }

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

    @ViewBuilder
    func makeDestination(_ route: AppRoute) -> some View {
        coordinator.destination(for: route)
    }
}
