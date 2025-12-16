//
//  APODRepository.swift
//  SpaceExplorer2.0
//
//  Created by Pab1m on 13.12.2025.
//

import Foundation
import SwiftData

final class APODRepository: APODRepositoryProtocol {

    private let service: APODService
    private let storage: APODStorageActor

    init(service: APODService, context: ModelContext) {
        self.service = service
        self.storage = APODStorageActor(context: context)
    }

    func loadAPOD() async throws -> APODResponse {
        do {
            let apod = try await service.fetchAPOD()
            try await storage.save(apod)
            return apod
        } catch {
            if let cached = try await storage.load() {
                return cached
            }
            throw error
        }
    }
}
