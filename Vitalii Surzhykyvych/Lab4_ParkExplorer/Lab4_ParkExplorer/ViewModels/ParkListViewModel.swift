//
//  ParkListViewModel.swift
//  Lab4_ParkExplorer
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

    private let repository: ParkRepositoryProtocol

    init(repository: ParkRepositoryProtocol) {
        self.repository = repository
    }

    func loadParks() async {
        isLoading = true
        errorMessage = nil

        do {
            parks = try await repository.fetchParks()
        } catch {
            parks = (try? await repository.loadCachedParks()) ?? []
            errorMessage = parks.isEmpty ? "Failed to load parks" : nil
        }

        isLoading = false
    }
}
