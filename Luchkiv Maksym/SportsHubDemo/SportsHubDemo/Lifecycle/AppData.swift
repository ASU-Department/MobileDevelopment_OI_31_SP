//
//  AppData.swift
//  SportsHubDemo
//
//  Created by Maksym on 02.11.2025.
//

import Foundation
import Combine

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
    
    func refreshFromNetwork() async {
        guard !isLoading else { return }
        
        isLoading = true
        lastError = nil
        
        do {
            let apiGames = try await BalldontlieClient.shared.fetchGames(
                season: 2024,
                perPage: 25
            )
            
            let mappedGames: [Game] = apiGames.map { dto in
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
                
                return Game(
                    home: home,
                    away: away,
                    homeScore: dto.home_team_score,
                    awayScore: dto.visitor_team_score,
                    isLive: isLive
                )
            }
            
            var teamSet = Set<Team>()
            for game in mappedGames {
                teamSet.insert(game.home)
                teamSet.insert(game.away)
            }
            
            self.allTeams = Array(teamSet).sorted { $0.short < $1.short }
            self.games = mappedGames
        } catch let error as NetworkError {
            lastError = error.errorDescription
        } catch {
            lastError = error.localizedDescription
        }
        
        isLoading = false
    }
}
