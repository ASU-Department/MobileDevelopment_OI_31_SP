//
//  ParkRepository.swift
//  Lab4_ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import SwiftData

final class ParkRepository: ParkRepositoryProtocol {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchParks() async throws -> [ParkAPIModel] {
        let apiParks = try await NPSService.shared.fetchParks()
        await saveParks(apiParks)
        return apiParks
    }

    func loadCachedParks() throws -> [ParkAPIModel] {
        let descriptor = FetchDescriptor<ParkEntity>()
        let entities = try modelContext.fetch(descriptor)
        return entities.map { ParkAPIModel(
            id: $0.id,
            fullName: $0.name,
            states: $0.state,
            description: $0.descriptionText,
            latitude: nil,
            longitude: nil,
            images: []
        )}
    }

    func saveParks(_ parks: [ParkAPIModel]) async {
        do {
            let existing = try modelContext.fetch(FetchDescriptor<ParkEntity>())
            for park in existing {
                modelContext.delete(park)
            }

            for park in parks {
                let entity = ParkEntity(from: park)
                modelContext.insert(entity)
            }

            try modelContext.save()
        } catch {
            print("Failed to save parks: \(error)")
        }
    }
}
