//
//  ArtworkDatabaseActor.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 11.12.2025.
//

import Foundation
import SwiftData

actor ArtworkDatabaseActor {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchAllArtworks() throws -> [Artwork] {
        let descriptor = FetchDescriptor<Artwork>(sortBy: [SortDescriptor(\Artwork.title)])
        return try modelContext.fetch(descriptor)
    }
    
    func fetchArtwork(byId id: Int) throws -> Artwork? {
        let descriptor = FetchDescriptor<Artwork>()
        let all = try modelContext.fetch(descriptor)
        return all.first { $0.id == id }
    }
    
    func saveArtworks(_ artworks: [Artwork]) throws {
        for artwork in artworks {
            modelContext.insert(artwork)
        }
        try modelContext.save()
    }
    
    func updateFavorite(artworkId: Int, isFavorite: Bool) throws {
        let descriptor = FetchDescriptor<Artwork>()
        let all = try modelContext.fetch(descriptor)
        if let artwork = all.first(where: { $0.id == artworkId }) {
            artwork.isFavorite = isFavorite
            try modelContext.save()
        }
    }
}
