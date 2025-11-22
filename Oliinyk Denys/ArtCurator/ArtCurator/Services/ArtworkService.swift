//
//  ArtworkService.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 08.11.2025.
//

import Foundation
import Combine
import SwiftData

@MainActor
class ArtworkService: ObservableObject {
    static let shared = ArtworkService()
    
    @Published var artworks: [Artwork] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isOffline = false
    
    private let baseApiURL = "https://collectionapi.metmuseum.org/public/collection/v1"
    
    func fetchArtworks(modelContext: ModelContext, query: String = "") async {
        isLoading = true
        errorMessage = nil
        isOffline = false
        
        do {
            let searchQuery = query.isEmpty ? "painting" : query
            let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchQuery
            let searchURL = URL(string: "\(baseApiURL)/search?hasImages=true&q=\(encodedQuery)")!
            let (searchData, _) = try await URLSession.shared.data(from: searchURL)
            
            let searchResponse = try JSONDecoder().decode(ArtworkSearchResponse.self, from: searchData)
            
            guard let objectIDs = searchResponse.objectIDs, !objectIDs.isEmpty else {
                errorMessage = "No artworks found for '\(searchQuery)'. Try a different query."
                isLoading = false
                return
            }
            
            let limitedIDs = Array(objectIDs.prefix(20))
            var fetchedArtworks: [Artwork] = []
            
            for objectID in limitedIDs {
                if let artwork = try? await fetchArtworkDetail(objectID: objectID) {
                    fetchedArtworks.append(artwork)
                }
            }
            
            try modelContext.delete(model: Artwork.self)
            
            for artwork in fetchedArtworks {
                modelContext.insert(artwork)
            }
            try modelContext.save()
            
            self.artworks = fetchedArtworks
            
            UserDefaults.standard.set(Date(), forKey: "lastFetchDate")
            UserDefaults.standard.set(query, forKey: "lastSearchQuery")
        } catch {
            errorMessage = "Failed to fetch artworks: \(error.localizedDescription)"
            loadFromLocalStorage(modelContext: modelContext)
        }
        
        isLoading = false
    }
    
    func loadFromLocalStorage(modelContext: ModelContext) {
        isOffline = true
        
        let fetchDescriptor = FetchDescriptor<Artwork>(
            sortBy: [SortDescriptor(\Artwork.title)]
        )
        
        do {
            let localArtworks = try modelContext.fetch(fetchDescriptor)
            self.artworks = localArtworks
            
            if localArtworks.isEmpty {
                errorMessage = "No cached data available. Please connect to internet."
            } else {
                errorMessage = "Showing cached data."
            }
        } catch {
            errorMessage = "Failed to load local data: \(error.localizedDescription)"
        }
    }
    
    private func fetchArtworkDetail(objectID: Int) async throws -> Artwork? {
        let objectURL = URL(string: "\(baseApiURL)/objects/\(objectID)")!
        let (objectData, _) = try await URLSession.shared.data(from: objectURL)
        let objectResponse = try JSONDecoder().decode(ArtworkObjectResponse.self, from: objectData)
        
        return Artwork(
            id: objectResponse.objectID,
            title: objectResponse.title.isEmpty ? "Untitled" : objectResponse.title,
            artistDisplayName: objectResponse.artistDisplayName.isEmpty ? "Unknown Artist" : objectResponse.artistDisplayName,
            primaryImageSmall: objectResponse.primaryImageSmall,
            primaryImage: objectResponse.primaryImage,
            objectDate: objectResponse.objectDate,
            medium: objectResponse.medium,
            department: objectResponse.department
        )
    }
}
