//
//  MockGamesRepository.swift
//  SportsHubDemo
//
//  Created by Codex on 2024-05-28.
//

#if DEBUG
import Foundation

final class MockGamesRepository: GamesRepositoryProtocol {
    var lastUpdateDate: Date?
    var cachedGames: [Game]
    var refreshResult: Result<[Game], Error>?
    var refreshDelayNanoseconds: UInt64?
    private(set) var refreshCallCount = 0
    private(set) var loadCachedCallCount = 0

    init(
        cachedGames: [Game] = [],
        refreshResult: Result<[Game], Error>? = nil,
        lastUpdateDate: Date? = nil,
        refreshDelayNanoseconds: UInt64? = nil
    ) {
        self.cachedGames = cachedGames
        self.refreshResult = refreshResult
        self.lastUpdateDate = lastUpdateDate
        self.refreshDelayNanoseconds = refreshDelayNanoseconds
    }

    func loadCachedGames() async -> [Game] {
        loadCachedCallCount += 1
        return cachedGames
    }

    func refreshGames() async throws -> [Game] {
        refreshCallCount += 1

        if let delay = refreshDelayNanoseconds {
            try await Task.sleep(nanoseconds: delay)
        }

        guard let refreshResult else { return cachedGames }

        switch refreshResult {
        case .success(let games):
            cachedGames = games
            if lastUpdateDate == nil {
                lastUpdateDate = Date()
            }
            return games
        case .failure(let error):
            throw error
        }
    }
}
#endif
