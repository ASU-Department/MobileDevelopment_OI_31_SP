//
//  AppCoordinator.swift
//  SportsHubDemo
//
//  Created by Maksym on 08.12.2025.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case teamsDirectory
    case team(Team)
    case game(Game, favorites: FavoriteFlags)

    struct FavoriteFlags: Hashable {
        let home: Bool
        let away: Bool
    }
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let repository: GamesRepositoryProtocol
    private(set) var latestTeams: [Team] = []

    init(repository: GamesRepositoryProtocol? = nil) {
        self.repository = repository ?? DefaultGamesRepository()
    }

    func makeGamesViewModel() -> GamesViewModel {
        GamesViewModel(repository: repository)
    }

    func makeTeamDetailViewModel(team: Team) -> TeamDetailViewModel {
        TeamDetailViewModel(team: team)
    }

    func makeGameDetailViewModel(game: Game, favorites: AppRoute.FavoriteFlags) -> GameDetailViewModel {
        GameDetailViewModel(
            game: game,
            isFavoriteHome: favorites.home,
            isFavoriteAway: favorites.away
        )
    }

    func showTeamsDirectory(with teams: [Team]) {
        latestTeams = teams
        path.append(AppRoute.teamsDirectory)
    }

    func push(_ route: AppRoute) {
        path.append(route)
    }
}
