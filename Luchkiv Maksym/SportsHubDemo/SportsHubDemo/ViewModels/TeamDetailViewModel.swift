//
//  TeamDetailViewModel.swift
//  SportsHubDemo
//
//  Created by Maksym on 08.12.2025.
//

import Combine
import Foundation

@MainActor
final class TeamDetailViewModel: ObservableObject {
    let team: Team
    let scopes: [StatScope] = StatScope.allCases
    @Published var selectedScopeIndex: Int = 1
    @Published var showBoxScore = false

    init(team: Team) {
        self.team = team
    }

    var currentScope: StatScope { scopes[selectedScopeIndex] }
    var playerStats: [PlayerStats] {
        SampleData.statsForTeam(short: team.short, scope: currentScope)
    }
}
