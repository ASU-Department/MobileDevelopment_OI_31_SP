//
//  AppCoordinator.swift
//  Lab1
//
//  Created by UnseenHand on 17.12.2025.
//

import Combine
import Foundation
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {

    @Published var path = NavigationPath()

    private let repository: GitHubRepositoryProtocol

    init(repository: GitHubRepositoryProtocol) {
        self.repository = repository
    }

    // Root
    func makeRootView() -> some View {
        let vm = RepoSearchViewModel(
            repository: repository,
            coordinator: self
        )
        return RepoSearchView(viewModel: vm)
    }

    // Navigation intents
    func openRepository(_ repo: Repository, developer: DeveloperProfile?) {
        path.append(AppRoute.repoDetails(repo, developer))
    }

    func openDeveloper(_ developer: DeveloperProfile) {
        path.append(AppRoute.developerProfile(developer))
    }

    // 🔑 Destination factory (THIS is what was missing)
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {

        case let .repoDetails(repo, developer):
            RepositoryDetailView(
                viewModel: RepoDetailViewModel(
                    repository: repo,
                    developer: developer,
                    coordinator: self
                )
            )

        case let .developerProfile(profile):
            DeveloperProfileView(
                viewModel: DeveloperProfileViewModel(profile: profile)
            )
        }
    }
}


enum AppRoute: Hashable {
    case repoDetails(Repository, DeveloperProfile?)
    case developerProfile(DeveloperProfile)
}

