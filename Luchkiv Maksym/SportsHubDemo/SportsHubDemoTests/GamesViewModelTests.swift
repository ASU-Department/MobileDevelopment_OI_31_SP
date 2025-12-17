//
//  GamesViewModelTests.swift
//  SportsHubDemoTests
//
//  Created by Maksym on 17.12.2025.
//
import Foundation
import Testing
@testable import SportsHubDemo

@Suite("GamesViewModel (Swift Testing)")
struct GamesViewModelTests {
    @Test
    @MainActor
    func loadFromCache_populatesGamesAndTeams() async throws {
        let repository = MockGamesRepository(cachedGames: SampleData.games)
        let favoritesStore = FavoriteStore(defaults: makeDefaults("favorites-load-cache"))
        let settings = AppSettingsStore(defaults: makeDefaults("settings-load-cache"))
        let viewModel = makeViewModel(repository: repository, favoritesStore: favoritesStore, settings: settings)

        await viewModel.loadFromCache()

        #expect(viewModel.games == SampleData.games)
        #expect(Set(viewModel.allTeams) == Set(SampleData.allTeams))
    }

    @Test
    @MainActor
    func refresh_updatesStateOnSuccess() async throws {
        let expectedDate = Date(timeIntervalSince1970: 123)
        let repository = MockGamesRepository(
            cachedGames: [],
            refreshResult: .success(Array(SampleData.games.prefix(2))),
            lastUpdateDate: expectedDate
        )
        let viewModel = makeViewModel(repository: repository)

        let succeeded = await viewModel.refresh()

        #expect(succeeded)
        #expect(viewModel.games.count == 2)
        #expect(viewModel.lastUpdateDate == expectedDate)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.lastError == nil)
    }

    @Test
    @MainActor
    func refresh_surfacesNetworkError() async {
        let repository = MockGamesRepository(refreshResult: .failure(NetworkError.badStatus(500)))
        let viewModel = makeViewModel(repository: repository)

        let succeeded = await viewModel.refresh()

        #expect(succeeded == false)
        #expect(viewModel.lastError == NetworkError.badStatus(500).errorDescription)
        #expect(viewModel.isLoading == false)
    }

    @Test
    @MainActor
    func refresh_returnsFalseWhenAlreadyLoading() async {
        let repository = MockGamesRepository(refreshResult: .success(SampleData.games))
        let viewModel = makeViewModel(repository: repository)
        viewModel.isLoading = true

        let succeeded = await viewModel.refresh()

        #expect(succeeded == false)
        #expect(repository.refreshCallCount == 0)
    }

    @Test
    @MainActor
    func filtering_respectsLiveOnlyAndQuery() async throws {
        let repository = MockGamesRepository(cachedGames: SampleData.games)
        let viewModel = makeViewModel(repository: repository)
        await viewModel.loadFromCache()

        viewModel.setShowLiveOnly(true)
        viewModel.setQuery("Warriors")

        let filtered = viewModel.filteredGames
        #expect(filtered.allSatisfy { $0.isLive })
        #expect(filtered.contains { $0.home == SampleData.warriors || $0.away == SampleData.warriors })
    }

    @Test
    @MainActor
    func updateFavorites_persistsToStore() {
        let favoritesStore = FavoriteStore(defaults: makeDefaults("favorites-update"))
        let repository = MockGamesRepository(cachedGames: SampleData.games)
        let viewModel = makeViewModel(repository: repository, favoritesStore: favoritesStore)

        let favorites: Set<Team> = [SampleData.lakers, SampleData.celtics]
        viewModel.updateFavorites(favorites)

        let persisted = favoritesStore.load()

        let expectedShorts = favorites.map(\.short).sorted()
        #expect(persisted.map(\.short).sorted() == expectedShorts)
        #expect(viewModel.favoriteTeams.map(\.short).sorted() == expectedShorts)
    }

    @Test
    @MainActor
    func tickLiveScores_onlyMutatesLiveGames() {
        let live = Game(home: SampleData.lakers, away: SampleData.warriors, homeScore: 101, awayScore: 99, isLive: true)
        let final = Game(home: SampleData.nets, away: SampleData.celtics, homeScore: 88, awayScore: 90, isLive: false)
        let repository = MockGamesRepository(cachedGames: [live, final])
        let viewModel = makeViewModel(repository: repository)
        viewModel.games = [live, final]

        viewModel.tickLiveScores()

        let updatedLive = viewModel.games.first { $0.isLive }
        let updatedFinal = viewModel.games.first { !$0.isLive }

        #expect(updatedFinal?.homeScore == final.homeScore)
        #expect(updatedFinal?.awayScore == final.awayScore)

        if let updatedLive {
            #expect(updatedLive.homeScore >= live.homeScore && updatedLive.homeScore <= live.homeScore + 1)
            #expect(updatedLive.awayScore >= live.awayScore && updatedLive.awayScore <= live.awayScore + 1)
        } else {
            Issue.record("Live game should still be present after tick")
        }
    }

    @MainActor
    private func makeViewModel(
        repository: MockGamesRepository,
        favoritesStore: FavoriteStore? = nil,
        settings: AppSettingsStore? = nil
    ) -> GamesViewModel {
        GamesViewModel(repository: repository, favoritesStore: favoritesStore, settings: settings)
    }

    private func makeDefaults(_ name: String) -> UserDefaults {
        let suite = UserDefaults(suiteName: name)!
        suite.removePersistentDomain(forName: name)
        return suite
    }
}
