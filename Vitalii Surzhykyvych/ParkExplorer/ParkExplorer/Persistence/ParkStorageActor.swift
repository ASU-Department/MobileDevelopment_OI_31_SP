//
//  ParkStorageActor.swift
//  ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import SwiftData

actor ParkStorageActor {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ parks: [ParkAPIModel]) {
        parks.forEach { park in
            let entity = ParkEntity(from: park)
            context.insert(entity)
        }
        try? context.save()
    }

    func load() -> [ParkAPIModel] {
        let descriptor = FetchDescriptor<ParkEntity>()
        let entities = (try? context.fetch(descriptor)) ?? []
        return entities.map { $0.toAPIModel() }
    }
}
