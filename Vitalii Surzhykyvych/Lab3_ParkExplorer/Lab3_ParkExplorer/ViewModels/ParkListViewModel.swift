//
//  ParkListViewModel.swift
//  Lab3_ParkExplorer
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

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadParks() async {
        isLoading = true
        errorMessage = nil

        do {
            let apiParks = try await NPSService.shared.fetchParks()
            parks = apiParks

            try saveToSwiftData(apiParks)

        } catch {
            errorMessage = "Offline mode. Showing saved parks."

            let savedParks = fetchFromSwiftData()
            parks = savedParks
        }

        isLoading = false
    }


    private func saveToSwiftData(_ apiParks: [ParkAPIModel]) throws {
        let existing = try modelContext.fetch(FetchDescriptor<ParkEntity>())
        for park in existing {
            modelContext.delete(park)
        }

        for park in apiParks {
            let entity = ParkEntity(from: park)
            modelContext.insert(entity)
        }

        try modelContext.save()
    }

    private func fetchFromSwiftData() -> [ParkAPIModel] {
        let descriptor = FetchDescriptor<ParkEntity>()

        guard let entities = try? modelContext.fetch(descriptor) else {
            return []
        }

        return entities.map {
            ParkAPIModel(
                id: $0.id,
                fullName: $0.name,
                states: $0.state,
                description: $0.descriptionText,
                latitude: nil,
                longitude: nil,
                images: []
            )
        }
    }
}
