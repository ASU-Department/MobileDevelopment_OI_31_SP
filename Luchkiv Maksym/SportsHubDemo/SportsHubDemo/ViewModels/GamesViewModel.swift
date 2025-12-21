//
//  GamesViewModel.swift
//  SportsHubDemo
//
//  Created by Maksym on 08.12.2025.
//

import Foundation
import Combine

@MainActor
final class GamesViewModel: ObservableObject {
    @Published var allTeams: [Team] = []
    @Published var games: [Game] = []
    @Published var favoriteTeams: Set<Team>
    @Published var showLiveOnly: Bool
    @Published var query: String
    @Published var isLoading = false
    @Published var lastError: String?
    @Published var lastUpdateDate: Date?

    private let repository: any GamesRepositoryProtocol
    private let favoritesStore: FavoriteStore
    private let settings: AppSettingsStore
    private var timer: AnyCancellable?

    init(
        repository: any GamesRepositoryProtocol,
        favoritesStore: FavoriteStore? = nil,
        settings: AppSettingsStore? = nil
    ) {
        self.repository = repository
        let resolvedFavorites = favoritesStore ?? .shared
        let resolvedSettings = settings ?? .shared
        self.favoritesStore = resolvedFavorites
        self.settings = resolvedSettings
        self.favoriteTeams = resolvedFavorites.load()
        self.showLiveOnly = resolvedSettings.showLiveOnly
        self.query = resolvedSettings.query
        self.lastUpdateDate = resolvedSettings.lastUpdateDate
    }

    func onAppear() {
        startLiveTicker()
    }

    func onDisappear() {
        timer?.cancel()
    }

    func loadInitial() async {
        await loadFromCache()
        await refresh()
    }

    func loadFromCache() async {
        let cached = await repository.loadCachedGames()
        updateState(with: cached)
    }

    @discardableResult
    func refresh() async -> Bool {
        guard !isLoading else { return false }
        isLoading = true
        lastError = nil
        do {
            let newGames = try await repository.refreshGames()
            updateState(with: newGames)
            lastUpdateDate = repository.lastUpdateDate
            isLoading = false
            return true
        } catch let error as NetworkError {
            lastError = error.errorDescription
        } catch {
            lastError = error.localizedDescription
        }
        isLoading = false
        return false
    }

    func updateFavorites(_ favorites: Set<Team>) {
        favoriteTeams = favorites
        favoritesStore.save(favorites)
    }

    func setShowLiveOnly(_ value: Bool) {
        showLiveOnly = value
        settings.showLiveOnly = value
    }

    func setQuery(_ value: String) {
        query = value
        settings.query = value
    }

    func tickLiveScores() {
        for i in games.indices {
            if games[i].isLive {
                games[i].homeScore += Int.random(in: 0...1)
                games[i].awayScore += Int.random(in: 0...1)
            }
        }
    }

    var filteredGames: [Game] {
        games.filter { g in
            let passesLive = showLiveOnly ? g.isLive : true
            let passesQuery =
                query.isEmpty ||
                g.home.name.localizedCaseInsensitiveContains(query) ||
                g.home.city.localizedCaseInsensitiveContains(query) ||
                g.away.name.localizedCaseInsensitiveContains(query) ||
                g.away.city.localizedCaseInsensitiveContains(query)
            return passesLive && passesQuery
        }
    }

    var sectionTitle: String { showLiveOnly ? "Live Games" : "Games" }

    private func startLiveTicker() {
        timer = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { @MainActor in self?.tickLiveScores() }
            }
    }

    private func updateState(with newGames: [Game]) {
        games = newGames
        var teamSet = Set<Team>()
        for g in newGames {
            teamSet.insert(g.home)
            teamSet.insert(g.away)
        }
        allTeams = Array(teamSet).sorted { $0.short < $1.short }
    }
}
