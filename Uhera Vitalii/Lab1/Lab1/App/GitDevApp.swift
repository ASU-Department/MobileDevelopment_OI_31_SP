//
//  Lab1App.swift
//  Lab1
//
//  Created by UnseenHand on 15.11.2025.
//

import SwiftUI

@main
struct GitDevApp: App {
    @StateObject private var coordinator: AppCoordinator

    init() {
        let persistenceActor = PersistenceActor()
        let apiService = GitHubAPIService()
        let repository = GitHubRepository(
            api: apiService,
            persistenceActor: persistenceActor
        )

        _coordinator = StateObject(
            wrappedValue: AppCoordinator(repository: repository)
        )
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.makeRootView()
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .appTheme()
        }
    }
}
