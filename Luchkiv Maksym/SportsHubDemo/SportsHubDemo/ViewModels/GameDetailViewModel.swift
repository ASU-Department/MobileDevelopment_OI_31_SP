//
//  GameDetailViewModel.swift
//  SportsHubDemo
//
//  Created by Maksym on 08.12.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class GameDetailViewModel: ObservableObject {
    let game: Game
    let isFavoriteHome: Bool
    let isFavoriteAway: Bool

    @Published var predictedHomeMargin: Double = 0
    @Published var showShareSheet = false

    init(game: Game, isFavoriteHome: Bool, isFavoriteAway: Bool) {
        self.game = game
        self.isFavoriteHome = isFavoriteHome
        self.isFavoriteAway = isFavoriteAway
    }

    var shareText: String {
        let line = "\(game.away.city) \(game.away.name) @ \(game.home.city) \(game.home.name)"
        let score = "\(game.awayScore) - \(game.homeScore) (\(game.statusText))"
        let prediction = String(format: "Predicted margin (home): %.0f", predictedHomeMargin)
        return "SportsHub:\n\(line)\n\(score)\n\(prediction)"
    }
}
