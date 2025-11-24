//
//  GameRecord.swift
//  SportsHubDemo
//
//  Created by Maksym on 18.11.2025.
//

import Foundation
import SwiftData

@Model
final class GameRecord {
    var apiId: Int
    var season: Int
    var statusText: String

    var homeShort: String
    var homeName: String
    var homeCity: String
    var homeScore: Int

    var awayShort: String
    var awayName: String
    var awayCity: String
    var awayScore: Int

    var isLive: Bool

    init(
        apiId: Int,
        season: Int,
        statusText: String,
        homeShort: String,
        homeName: String,
        homeCity: String,
        homeScore: Int,
        awayShort: String,
        awayName: String,
        awayCity: String,
        awayScore: Int,
        isLive: Bool
    ) {
        self.apiId = apiId
        self.season = season
        self.statusText = statusText
        self.homeShort = homeShort
        self.homeName = homeName
        self.homeCity = homeCity
        self.homeScore = homeScore
        self.awayShort = awayShort
        self.awayName = awayName
        self.awayCity = awayCity
        self.awayScore = awayScore
        self.isLive = isLive
    }
}
