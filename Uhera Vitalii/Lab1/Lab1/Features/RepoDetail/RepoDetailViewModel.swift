//
//  RepositoryDetailViewModel.swift
//  Lab1
//
//  Created by UnseenHand on 17.12.2025.
//

import Combine
import Foundation

@MainActor
final class RepoDetailViewModel: ObservableObject {
    @Published var showShare: Bool = false

    let repository: Repository
    let developer: DeveloperProfile?
    private let coordinator: AppCoordinator

    init(
        repository: Repository,
        developer: DeveloperProfile?,
        coordinator: AppCoordinator
    ) {
        self.repository = repository
        self.developer = developer
        self.coordinator = coordinator
    }

    func openDeveloperProfile() {
        guard let developer else { return }
        coordinator.openDeveloper(developer)
    }

    func shareTapped() {
        showShare = true
    }
}
