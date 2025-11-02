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
}
