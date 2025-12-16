//
//  GamesRepository.swift
//  SportsHubDemo
//
//  Created by Maksym on 08.12.2025.
//

import Foundation
import SwiftData

protocol GamesRepositoryProtocol {
    var lastUpdateDate: Date? { get }
    func loadCachedGames() async -> [Game]
    func refreshGames() async throws -> [Game]
}

final class DefaultGamesRepository: GamesRepositoryProtocol {
    private let api: BalldontlieClient
    private let cache: GameCacheActor
    private let settings: AppSettingsStore

    init(
        api: BalldontlieClient = .shared,
        container: ModelContainer,
        settings: AppSettingsStore = .shared
    ) {
        self.api = api
        self.cache = GameCacheActor(container: container)
        self.settings = settings
    }

    var lastUpdateDate: Date? { settings.lastUpdateDate }

    func loadCachedGames() async -> [Game] {
        await cache.loadGames()
    }

    func refreshGames() async throws -> [Game] {
        let apiGames = try await api.fetchGames(season: 2024, perPage: 25)
        let mappedGames: [Game] = apiGames.map { dto in
            let home = Team(name: dto.home_team.name, city: dto.home_team.city, short: dto.home_team.abbreviation)
            let away = Team(name: dto.visitor_team.name, city: dto.visitor_team.city, short: dto.visitor_team.abbreviation)
            let isLive = dto.status != "Final"
            return Game(home: home, away: away, homeScore: dto.home_team_score, awayScore: dto.visitor_team_score, isLive: isLive)
        }

        await cache.save(apiGames: apiGames)
        let now = Date()
        settings.lastUpdateDate = now
        return mappedGames
    }
}
