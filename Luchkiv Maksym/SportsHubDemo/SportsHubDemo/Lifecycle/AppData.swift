//
//  AppData.swift
//  SportsHubDemo
//
//  Created by Maksym on 02.11.2025.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class AppDataStore: ObservableObject {
    @Published var allTeams: [Team] = []
    @Published var games: [Game] = []
    
    @Published var isLoading: Bool = false
    @Published var lastError: String?

    func loadMockData() {
        // called once at startup by AppDelegate
        self.allTeams = SampleData.allTeams
        self.games = SampleData.games
    }

    func tickLiveScores() {
        for i in games.indices {
            if games[i].isLive {
                games[i].homeScore += Int.random(in: 0...1)
                games[i].awayScore += Int.random(in: 0...1)
            }
        }
    }
    
    func loadFromCache(using context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<GameRecord>()
            let records = try context.fetch(descriptor)
            guard !records.isEmpty else { return }
            
            let loadedGames: [Game] = records.map { rec in
                let home = Team(
                    name: rec.homeName,
                    city: rec.homeCity,
                    short: rec.homeShort
                )
                let away = Team(
                    name: rec.awayName,
                    city: rec.awayCity,
                    short: rec.awayShort
                )
                return Game(
                    home: home,
                    away: away,
                    homeScore: rec.homeScore,
                    awayScore: rec.awayScore,
                    isLive: rec.isLive
                )
            }
            
            var teamSet = Set<Team>()
            for g in loadedGames {
                teamSet.insert(g.home)
                teamSet.insert(g.away)
            }
            
            self.games = loadedGames
            self.allTeams = Array(teamSet).sorted { $0.short < $1.short }
        } catch {
            print("Failed to load cache: \(error)")
        }
    }
    
    func refreshFromNetwork(using context: ModelContext) async {
        guard !isLoading else { return }
        
        isLoading = true
        lastError = nil
        
        do {
            let apiGames = try await BalldontlieClient.shared.fetchGames(
                season: 2024,
                perPage: 25
            )
            
            var mappedGames: [Game] = []
            var teamSet = Set<Team>()
            
            for dto in apiGames {
                let home = Team(
                    name: dto.home_team.name,
                    city: dto.home_team.city,
                    short: dto.home_team.abbreviation
                )
                let away = Team(
                    name: dto.visitor_team.name,
                    city: dto.visitor_team.city,
                    short: dto.visitor_team.abbreviation
                )
                
                // Liveness check, BDL docs say that Final is for completed games
                let isLive = dto.status != "Final"
                
                let game = Game(
                    home: home,
                    away: away,
                    homeScore: dto.home_team_score,
                    awayScore: dto.visitor_team_score,
                    isLive: isLive
                )
                
                mappedGames.append(game)
                teamSet.insert(home)
                teamSet.insert(away)
            }
            
            self.games = mappedGames
            self.allTeams = Array(teamSet).sorted { $0.short < $1.short }
            
            do {
                let existing = try context.fetch(FetchDescriptor<GameRecord>())
                for rec in existing {
                    context.delete(rec)
                }
                
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
                print("Failed to write SwiftData cache: \(error)")
            }
        } catch let error as NetworkError {
            lastError = error.errorDescription
        } catch {
            lastError = error.localizedDescription
        }
        
        isLoading = false
    }
}
