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
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var isOffline = false
    
    private let baseApiURL = "https://collectionapi.metmuseum.org/public/collection/v1"
    private var allObjectIDs: [Int] = []
    private var currentOffset = 0
    private let pageSize = 20
    
    var hasMorePages: Bool {
        currentOffset < allObjectIDs.count
    }
    
    func fetchArtworks(modelContext: ModelContext, query: String = "") async {
        isLoading = true
        errorMessage = nil
        isOffline = false
        currentOffset = 0
        
        do {
            let searchQuery = query.isEmpty ? "painting" : query
            allObjectIDs = try await searchArtworks(query: searchQuery)
            
            guard !allObjectIDs.isEmpty else {
                errorMessage = "No artworks found for '\(searchQuery)'. Try a different query."
                isLoading = false
                return
            }
            
            let firstBatch = Array(allObjectIDs.prefix(pageSize))
            currentOffset = firstBatch.count
            
            let fetchedArtworks = await fetchAndSaveArtworks(objectIDs: firstBatch, modelContext: modelContext)
            self.artworks = fetchedArtworks
            
            saveSearchState(query: query)
        } catch {
            errorMessage = "Failed to fetch artworks: \(error.localizedDescription)"
            loadFromLocalStorage(modelContext: modelContext)
        }
        
        isLoading = false
    }
    
    func loadMoreArtworks(modelContext: ModelContext) async {
        guard !isLoading && !isLoadingMore && hasMorePages else { return }
        
        isLoadingMore = true
        
        let nextBatch = Array(allObjectIDs[currentOffset..<min(currentOffset + pageSize, allObjectIDs.count)])
        currentOffset += nextBatch.count
        
        let fetchedArtworks = await fetchAndSaveArtworks(objectIDs: nextBatch, modelContext: modelContext)
        self.artworks.append(contentsOf: fetchedArtworks)
        
        isLoadingMore = false
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
    
    private func searchArtworks(query: String) async throws -> [Int] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let searchURL = URL(string: "\(baseApiURL)/search?hasImages=true&q=\(encodedQuery)")!
        let (searchData, _) = try await URLSession.shared.data(from: searchURL)
        let searchResponse = try JSONDecoder().decode(ArtworkSearchResponse.self, from: searchData)
        return searchResponse.objectIDs ?? []
    }
    
    private func fetchAndSaveArtworks(objectIDs: [Int], modelContext: ModelContext) async -> [Artwork] {
        var fetchedArtworks: [Artwork] = []
        
        for objectID in objectIDs {
            if let artwork = try? await fetchArtworkDetail(objectID: objectID, modelContext: modelContext) {
                fetchedArtworks.append(artwork)
            }
        }
        
        for artwork in fetchedArtworks {
            modelContext.insert(artwork)
        }
        try? modelContext.save()
        
        return fetchedArtworks
    }
    
    private func saveSearchState(query: String) {
        UserDefaults.standard.set(query, forKey: "searchQuery")
    }
    
    private func fetchArtworkDetail(objectID: Int, modelContext: ModelContext) async throws -> Artwork? {
        let descriptor = FetchDescriptor<Artwork>(
            predicate: #Predicate { $0.id == objectID }
        )
        
        if let existingArtwork = try? modelContext.fetch(descriptor).first {
            return existingArtwork
        }
        
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
