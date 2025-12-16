//
//  APODStorage.swift
//  SpaceExplorer2.0
//
//  Created by Pab1m on 13.12.2025.
//

import Foundation
import SwiftData

actor APODStorageActor {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func save(_ apod: APODResponse) async throws {
        let request = FetchDescriptor<CachedAPOD>()
        let items = try context.fetch(request)

        for item in items {
            context.delete(item)
        }

        let cached = CachedAPOD(
            title: apod.title,
            explanation: apod.explanation,
            url: apod.url,
            mediaType: apod.media_type
        )

        context.insert(cached)
    }

    func load() async throws -> APODResponse? {
        let request = FetchDescriptor<CachedAPOD>(
            sortBy: [.init(\.savedAt, order: .reverse)]
        )

        return try context.fetch(request).first?.toResponse()
    }
}
