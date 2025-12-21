//
//  ArtworkRepository.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 11.12.2025.
//

import Foundation
import SwiftData

@MainActor
protocol ArtworkRepositoryProtocol {
    func searchArtworks(query: String) async throws -> [Int]
    func fetchArtworkDetail(objectID: Int) async throws -> Artwork?
    func loadLocalArtworks() async throws -> [Artwork]
    func saveArtworks(_ artworks: [Artwork]) async throws
    func updateFavorite(artworkId: Int, isFavorite: Bool) async throws
}

@MainActor
class ArtworkRepository: ArtworkRepositoryProtocol {
    private let baseApiURL = "https://collectionapi.metmuseum.org/public/collection/v1"
    private let databaseActor: ArtworkDatabaseActor
    
    init(databaseActor: ArtworkDatabaseActor) {
        self.databaseActor = databaseActor
    }
    
    func searchArtworks(query: String) async throws -> [Int] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let searchURL = URL(string: "\(baseApiURL)/search?hasImages=true&q=\(encodedQuery)")!
        let (searchData, _) = try await URLSession.shared.data(from: searchURL)
        let searchResponse = try JSONDecoder().decode(ArtworkSearchResponse.self, from: searchData)
        return searchResponse.objectIDs ?? []
    }
    
    func fetchArtworkDetail(objectID: Int) async throws -> Artwork? {
        if let existing = try await databaseActor.fetchArtwork(byId: objectID) {
            return existing
        }
        
        let objectURL = URL(string: "\(baseApiURL)/objects/\(objectID)")!
        let (objectData, _) = try await URLSession.shared.data(from: objectURL)
        let response = try JSONDecoder().decode(ArtworkObjectResponse.self, from: objectData)
        
        return Artwork(
            id: response.objectID,
            title: response.title.isEmpty ? "Untitled" : response.title,
            artistDisplayName: response.artistDisplayName.isEmpty ? "Unknown Artist" : response.artistDisplayName,
            primaryImageSmall: response.primaryImageSmall,
            primaryImage: response.primaryImage,
            objectDate: response.objectDate,
            medium: response.medium,
            department: response.department
        )
    }
    
    func loadLocalArtworks() async throws -> [Artwork] {
        try await databaseActor.fetchAllArtworks()
    }
    
    func saveArtworks(_ artworks: [Artwork]) async throws {
        try await databaseActor.saveArtworks(artworks)
    }
    
    func updateFavorite(artworkId: Int, isFavorite: Bool) async throws {
        try await databaseActor.updateFavorite(artworkId: artworkId, isFavorite: isFavorite)
    }
}
