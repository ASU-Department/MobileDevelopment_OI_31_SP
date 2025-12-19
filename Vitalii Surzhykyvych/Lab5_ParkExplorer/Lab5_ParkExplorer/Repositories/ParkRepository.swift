//
//  ParkRepository.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import SwiftData

final class ParkRepository: ParkRepositoryProtocol {

    private let api: NPSService
    private let storage: ParkStorageActor

    init(api: NPSService, storage: ParkStorageActor) {
        self.api = api
        self.storage = storage
    }

    func fetchParks() async throws -> [ParkAPIModel] {
        let parks = try await api.fetchParks()
        await storage.save(parks)
        return parks
    }

    func loadCachedParks() async throws -> [ParkAPIModel] {
        return await storage.load()
    }

    func saveParks(_ parks: [ParkAPIModel]) async {
        await storage.save(parks)
    }
}
