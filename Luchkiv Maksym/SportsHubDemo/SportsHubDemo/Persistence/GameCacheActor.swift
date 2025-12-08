//
//  GameCacheActor.swift
//  SportsHubDemo
//
//  Created by Maksym on 08.12.2025.
//

import Foundation
import SwiftData

actor GameCacheActor {
    private let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: GameRecord.self)
        } catch {
            fatalError("Failed to create cache container: \(error)")
        }
    }

    func loadGames() -> [Game] {
        let context = ModelContext(container)
        do {
            let records = try context.fetch(FetchDescriptor<GameRecord>())
            return records.map { rec in
                let home = Team(name: rec.homeName, city: rec.homeCity, short: rec.homeShort)
                let away = Team(name: rec.awayName, city: rec.awayCity, short: rec.awayShort)
                return Game(home: home, away: away, homeScore: rec.homeScore, awayScore: rec.awayScore, isLive: rec.isLive)
            }
        } catch {
            print("Cache load failed: \(error)")
            return []
        }
    }

    func save(apiGames: [BDLGame]) {
        let context = ModelContext(container)
        do {
            let existing = try context.fetch(FetchDescriptor<GameRecord>())
            existing.forEach { context.delete($0) }

            for dto in apiGames {
                let isLive = dto.status != "Final"
                let record = GameRecord(
                    apiId: dto.id,
                    season: dto.season,
                    statusText: dto.status,
                    homeShort: dto.home_team.abbreviation,
                    homeName: dto.home_team.name,
                    homeCity: dto.home_team.city,
                    homeScore: dto.home_team_score,
                    awayShort: dto.visitor_team.abbreviation,
                    awayName: dto.visitor_team.name,
                    awayCity: dto.visitor_team.city,
                    awayScore: dto.visitor_team_score,
                    isLive: isLive
                )
                context.insert(record)
            }
            try context.save()
        } catch {
            print("Cache save failed: \(error)")
        }
    }
}
