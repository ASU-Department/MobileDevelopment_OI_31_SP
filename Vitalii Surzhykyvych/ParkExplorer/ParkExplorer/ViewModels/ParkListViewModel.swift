//
//  ParkListViewModel.swift
//  ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import SwiftUI
import Combine
import SwiftData

@MainActor
final class ParkListViewModel: ObservableObject {

    @Published var parks: [ParkAPIModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastUpdateText: String?

    private let repository: ParkRepositoryProtocol

    init(repository: ParkRepositoryProtocol) {
        self.repository = repository
        updateLastUpdateText()
    }

    func loadParks() async {
        isLoading = true
        errorMessage = nil

        do {
            parks = try await repository.fetchParks()
            UserSettings.lastUpdate = Date()
            updateLastUpdateText()
        } catch {
            parks = (try? await repository.loadCachedParks()) ?? []
            errorMessage = parks.isEmpty ? "Failed to load parks" : nil
        }

        isLoading = false
    }

    private func updateLastUpdateText() {
        guard let date = UserSettings.lastUpdate else {
            lastUpdateText = nil
            return
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        lastUpdateText = "Last updated: \(formatter.string(from: date))"
    }
}
