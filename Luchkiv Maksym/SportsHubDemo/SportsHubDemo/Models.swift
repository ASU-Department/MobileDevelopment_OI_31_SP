//
//  Models.swift
//  SportsHubDemo
//
//  Created by Maksym on 19.10.2025.
//
import Foundation
import SwiftUI

enum AppColor {
    static let accent = Color(red: 0.82, green: 0.65, blue: 0.98)
    static let secondary = Color(red: 0.94, green: 0.93, blue: 0.98)
    static let favorite = Color(red: 0.95, green: 0.90, blue: 0.45)
}

struct Team: Identifiable, Hashable, Codable {
    let id = UUID()
    let name: String
    let city: String
    let short: String
    
    // It is made to tell the Codable to only use these keys for encoding and decording (JSON etc)
    // Since id is not in this list, it will be ignore
    // This was made cause of conflict where Decodable wants to overwrite the already given constant (id)
    private enum CodingKeys: String, CodingKey {
        case name, city, short
    }
}

struct Game: Identifiable, Hashable, Codable {
    let id = UUID()
    let home: Team
    let away: Team
    var homeScore: Int
    var awayScore: Int
    var isLive: Bool
    var statusText: String { isLive ? "LIVE" : "Final" }
    
    private enum CodingKeys: String, CodingKey {
        case home, away, homeScore, awayScore, isLive
    }
}

enum StatScope: String, CaseIterable, Identifiable {
    case last10 = "Last 10"
    case season = "Season Avg"
    var id: String { rawValue }
}

// MARK: - Players & Stats (mock)
struct Player: Identifiable, Hashable, Codable {
    let id = UUID()
    let name: String
    let teamShort: String
    
    private enum CodingKeys: String, CodingKey {
        case name, teamShort
    }
}

struct PlayerStats: Identifiable, Hashable, Codable {
    let id = UUID()
    let player: Player
    let season: String   // e.g. "2024-25"
    let gp: Int
    let pts: Double
    let reb: Double
    let ast: Double
    
    private enum CodingKeys: String, CodingKey {
        case player, season, gp, pts, reb, ast
    }
}

enum SampleData {
    // MARK: - Teams
    static let lakers = Team(name: "Lakers", city: "Los Angeles", short: "LAL")
    static let warriors = Team(name: "Warriors", city: "Golden State", short: "GSW")
    static let celtics = Team(name: "Celtics", city: "Boston", short: "BOS")
    static let nets = Team(name: "Nets", city: "Brooklyn", short: "BKN")
    static let bulls = Team(name: "Bulls", city: "Chicago", short: "CHI")
    static let heat = Team(name: "Heat", city: "Miami", short: "MIA")
    static let knicks = Team(name: "Knicks", city: "New York", short: "NYK")
    static let mavs = Team(name: "Mavericks", city: "Dallas", short: "DAL")
    static let suns = Team(name: "Suns", city: "Phoenix", short: "PHX")
    static let nuggets = Team(name: "Nuggets", city: "Denver", short: "DEN")
    static let bucks = Team(name: "Bucks", city: "Milwaukee", short: "MIL")
    static let spurs = Team(name: "Spurs", city: "San Antonio", short: "SAS")

    static let allTeams: [Team] = [
        lakers, warriors, celtics, nets, bulls, heat,
        knicks, mavs, suns, nuggets, bucks, spurs
    ]
    
    static let players: [Player] = [
        Player(name: "Stephen Curry", teamShort: "GSW"),
        Player(name: "LeBron James", teamShort: "LAL"),
        Player(name: "Jayson Tatum", teamShort: "BOS")
    ]
    
    static let playerStats: [PlayerStats] = [
        PlayerStats(player: players[0], season: "2024-25", gp: 10, pts: 29.8, reb: 4.7, ast: 6.1),
        PlayerStats(player: players[1], season: "2024-25", gp: 10, pts: 27.2, reb: 8.0, ast: 7.1),
        PlayerStats(player: players[2], season: "2024-25", gp: 10, pts: 26.4, reb: 8.6, ast: 4.0)
    ]
    
    static func statsForTeam(short: String, scope: StatScope) -> [PlayerStats] {
        playerStats.filter { $0.player.teamShort == short }
    }

    // MARK: - Games
    static let games: [Game] = [
        Game(home: lakers, away: warriors, homeScore: 108, awayScore: 104, isLive: true),
        Game(home: nets, away: celtics, homeScore: 110, awayScore: 115, isLive: false),
        Game(home: bulls, away: heat, homeScore: 99, awayScore: 96, isLive: false),
        Game(home: mavs, away: suns, homeScore: 112, awayScore: 118, isLive: true),
        Game(home: nuggets, away: bucks, homeScore: 121, awayScore: 113, isLive: false),
        Game(home: spurs, away: knicks, homeScore: 95, awayScore: 100, isLive: false),
        Game(home: heat, away: celtics, homeScore: 109, awayScore: 103, isLive: false),
        Game(home: warriors, away: nuggets, homeScore: 119, awayScore: 120, isLive: true),
        Game(home: bulls, away: bucks, homeScore: 101, awayScore: 92, isLive: false),
        Game(home: suns, away: mavs, homeScore: 97, awayScore: 100, isLive: false),
        Game(home: lakers, away: spurs, homeScore: 122, awayScore: 110, isLive: false),
        Game(home: knicks, away: nets, homeScore: 98, awayScore: 99, isLive: true),
        Game(home: bucks, away: heat, homeScore: 114, awayScore: 111, isLive: false),
        Game(home: celtics, away: warriors, homeScore: 102, awayScore: 108, isLive: false),
        Game(home: mavs, away: bulls, homeScore: 107, awayScore: 109, isLive: false),
        Game(home: suns, away: lakers, homeScore: 111, awayScore: 117, isLive: false),
        Game(home: nuggets, away: spurs, homeScore: 118, awayScore: 101, isLive: false),
        Game(home: nets, away: bucks, homeScore: 106, awayScore: 110, isLive: false),
        Game(home: heat, away: knicks, homeScore: 101, awayScore: 98,  isLive: true),
        Game(home: warriors, away: bulls, homeScore: 115, awayScore: 112, isLive: false)
    ]
}

