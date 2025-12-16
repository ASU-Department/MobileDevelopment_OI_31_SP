//
//  AppCoordinatorView.swift
//  SportsHubDemo
//
//  Created by Maksym on 08.12.2025.
//

import SwiftUI
import SwiftData

struct AppCoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator
    
    init(container: ModelContainer) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ContentView(viewModel: coordinator.makeGamesViewModel())
                .environmentObject(coordinator)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .teamsDirectory:
                        TeamsDirectoryView(allTeams: coordinator.latestTeams)
                            .environmentObject(coordinator)
                    case .team(let team):
                        TeamDetailView(viewModel: coordinator.makeTeamDetailViewModel(team: team))
                    case .game(let game, let favorites):
                        GameDetailView(
                            viewModel: coordinator.makeGameDetailViewModel(game: game, favorites: favorites)
                        )
                    }
                }
        }
    }
}

#Preview {
    AppCoordinatorView(container: PreviewContainer.shared)
        .modelContainer(PreviewContainer.shared)
}

