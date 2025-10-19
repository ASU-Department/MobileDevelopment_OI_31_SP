//
//  Models.swift
//  SportsHubDemo
//
//  Created by Maksym on 19.10.2025.
//
import Foundation

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

