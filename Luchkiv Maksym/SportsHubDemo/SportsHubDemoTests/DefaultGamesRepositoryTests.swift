//
//  DefaultGamesRepository.swift
//  SportsHubDemoTests
//
//  Created by Maksym on 17.12.2025.
//
import Foundation
import SwiftData
import Testing
@testable import SportsHubDemo

@MainActor
@Suite("DefaultGamesRepository")
struct DefaultGamesRepositoryTests {
    @Test
    func refreshMapsDtoAndCaches() async throws {
        let api = MockAPI(result: .success([TestHelpers.makeBDLGame(status: "In Progress", homeScore: 50, awayScore: 45)]))
        let container = try TestHelpers.makeInMemoryContainer()
        let settings = AppSettingsStore(defaults: makeDefaults("repo-success"))
        let repository = DefaultGamesRepository(api: api, container: container, settings: settings)

        let games = try await repository.refreshGames()

        #expect(games.count == 1)
        let expected = try #require(games.first)
        #expect(expected.homeScore == 50)
        #expect(expected.awayScore == 45)
        #expect(expected.isLive == true)
        #expect(repository.lastUpdateDate != nil)

        let cacheReader = GameCacheActor(container: container)
        let cached = await cacheReader.loadGames()

        #expect(cached.count == 1)
        let cachedGame = try #require(cached.first)
        #expect(cachedGame.home.short == expected.home.short)
        #expect(cachedGame.away.short == expected.away.short)
        #expect(cachedGame.homeScore == expected.homeScore)
        #expect(cachedGame.awayScore == expected.awayScore)
        #expect(cachedGame.isLive == expected.isLive)
    }

    @Test
    func refreshPropagatesApiError() async throws {
        let api = MockAPI(result: .failure(NetworkError.badStatus(503)))
        let container = try TestHelpers.makeInMemoryContainer()
        let repository = DefaultGamesRepository(api: api, container: container, settings: AppSettingsStore(defaults: makeDefaults("repo-failure")))

        do {
            _ = try await repository.refreshGames()
            Issue.record("Expected refreshGames to throw")
        } catch let error as NetworkError {
            #expect(error == .badStatus(503))
        }
    }

    private func makeDefaults(_ name: String) -> UserDefaults {
        let suite = UserDefaults(suiteName: name)!
        suite.removePersistentDomain(forName: name)
        return suite
    }
}

private final class MockAPI: BalldontlieAPIProtocol {
    var result: Result<[BDLGame], Error>

    init(result: Result<[BDLGame], Error>) {
        self.result = result
    }

    func fetchGames(season: Int, perPage: Int) async throws -> [BDLGame] {
        switch result {
        case .success(let games):
            return games
        case .failure(let error):
            throw error
        }
    }
}
	
