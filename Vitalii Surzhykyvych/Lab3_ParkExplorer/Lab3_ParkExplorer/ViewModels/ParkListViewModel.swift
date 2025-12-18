//
//  ParkListViewModel.swift
//  Lab3_ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import SwiftUI
import Combine

@MainActor
final class ParkListViewModel: ObservableObject {
    @Published var parks: [ParkAPIModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadParks() async {
        isLoading = true
        errorMessage = nil

        do {
            parks = try await NPSService.shared.fetchParks()
        } catch {
            errorMessage = "Failed to load parks"
        }

        isLoading = false
    }
}
