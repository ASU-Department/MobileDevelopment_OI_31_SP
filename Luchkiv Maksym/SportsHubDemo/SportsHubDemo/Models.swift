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

struct Gamee: Identifiable, Hashable, Codable {
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
    static let lakers = Team(name: "Lakers", city: "Los Angeles", short: "LAL")
    static let warriors = Team(name: "Warriors", city: "Golden State", short: "GSW")
    static let celtics = Team(name: "Celtics", city: "Boston", short: "BOS")
    static let nets = Team(name: "Nets", city: "Brooklyn", short: "BKN")
    
    static let allTeams: [Team] = [lakers, warriors, celtics, nets]
    
    static let games: [Gamee] = [
        Gamee(home: lakers, away: warriors, homeScore: 102, awayScore: 98, isLive: true),
        Gamee(home: nets, away: celtics, homeScore: 108, awayScore: 110, isLive: false),
        Gamee(home: celtics, away: lakers, homeScore: 89, awayScore: 94, isLive: false),
    ]
}

