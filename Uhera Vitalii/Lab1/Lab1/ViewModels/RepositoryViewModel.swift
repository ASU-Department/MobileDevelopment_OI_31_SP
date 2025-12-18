//
//  RepositoryViewModel.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//

import Combine
import Foundation
import SwiftUI

final class RepositoryViewModel: ObservableObject {
    @AppStorage("lastUsername") private var storedUsername = "octocat"
    @AppStorage("useSliderMode") private var storedUseSliderMode = true
    @AppStorage("sortMode") private var storedSortModeRaw = RepoSortMode.stars.rawValue
    @AppStorage("minStars") var storedMinStars: Double = 0
    @AppStorage("minIssues") var storedMinIssues: Double = 0
    @AppStorage("minWatchers") var storedMinWatchers: Double = 0
    @AppStorage("showOnlyStarred") var storedShowOnlyStarred = false
    
    @Published var username: String = "octocat" {
        didSet { storedUsername = username }
    }

    @Published var useSliderMode: Bool = true {
        didSet { storedUseSliderMode = useSliderMode }
    }

    @Published var sortMode: RepoSortMode = .stars {
        didSet { storedSortModeRaw = sortMode.rawValue }
    }
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isOffline = false

    @Published var searchText: String = ""
    @Published var showAdvancedFilters = false
    @Published var languageFilter: String = "Any"
    @Published var showOnlyStarred = false
    @Published var showOnlyWithIssues = false
    @Published var minStars: Double = 0 {
        didSet { storedMinStars = minStars }
    }
    @Published var minWatchers: Double = 0 {
        didSet { storedMinWatchers = minWatchers }
    }
    @Published var minIssues: Double = 0 {
        didSet { storedMinIssues = minIssues }
    }

    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var developers: [DeveloperProfile] = []

    @Published private(set) var starredRepoIds: Set<Int> = []

    private let api: GitHubAPIServiceProtocol
    private let persistence: PersistenceStore

    init(
        api: GitHubAPIServiceProtocol = GitHubAPIService(),
        persistence: PersistenceStore = .shared
    ) {
        self.api = api
        self.persistence = persistence
        _username = Published(initialValue: storedUsername)
        _useSliderMode = Published(initialValue: storedUseSliderMode)
        _sortMode = Published(
            initialValue: RepoSortMode(rawValue: storedSortModeRaw) ?? .stars
        )
        _minStars = Published(initialValue: storedMinStars)
        _minWatchers = Published(initialValue: storedMinWatchers)
        _minIssues = Published(initialValue: storedMinIssues)
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let userDTO = try await api.fetchUser(username: username)
            let repoDTOs = try await api.fetchRepositories(username: username)

            let developer = DeveloperProfile(dto: userDTO)
            let repos = repoDTOs.map { Repository(dto: $0) }

            self.developers = [developer]
            self.repositories = repos

            persistence.save(repositories: repos, developers: [developer])
            isOffline = false

        } catch {
            isOffline = true
            errorMessage = error.localizedDescription
            loadFromCache()
        }

        isLoading = false
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

    private func loadFromCache() {
        let cached: [CachedRepository] = persistence.fetch()

        let filtered = cached.filter {
            $0.ownerLogin.lowercased() == username.lowercased()
        }

        repositories = filtered.map {
            Repository(
                id: $0.id,
                name: $0.name,
                fullName: $0.fullName,
                description: nil,
                htmlUrl: nil,
                language: $0.language,
                stargazersCount: $0.stars,
                watchersCount: $0.watchers,
                forksCount: 0,
                openIssuesCount: $0.issues,
                defaultBranch: "main",
                createdAt: Date(),
                updatedAt: Date(),
                owner: RepositoryOwner(
                    login: $0.ownerLogin,
                    avatarUrl: nil,
                    location: nil
                )
            )
        }

        if filtered.isEmpty {
            errorMessage = "No cached data for user \(username)"
        }
    }
}
