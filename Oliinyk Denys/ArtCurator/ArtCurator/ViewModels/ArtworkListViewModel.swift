//
//  ArtworkListViewModel.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 08.11.2025.
//

import Foundation
import Combine
import SwiftData

@MainActor
class ArtworkListViewModel: ObservableObject {
    @Published var artworks: [Artwork] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var isOffline = false
    @Published var searchQuery = ""
    @Published var filterFavorites = false
    
    private let repository: ArtworkRepositoryProtocol
    private var allObjectIDs: [Int] = []
    private var currentOffset = 0
    private let pageSize = 20
    
    var hasMorePages: Bool {
        currentOffset < allObjectIDs.count
    }
    
    var filteredArtworks: [Artwork] {
        artworks.filter { !filterFavorites || $0.isFavorite }
    }
    
    init(repository: ArtworkRepositoryProtocol) {
        self.repository = repository
        self.filterFavorites = UserDefaults.standard.bool(forKey: "filterFavorites")
        self.searchQuery = UserDefaults.standard.string(forKey: "searchQuery") ?? ""
    }
    
    func fetchArtworks() async {
        isLoading = true
        errorMessage = nil
        isOffline = false
        currentOffset = 0
        
        do {
            let query = searchQuery.isEmpty ? "painting" : searchQuery
            allObjectIDs = try await repository.searchArtworks(query: query)
            
            guard !allObjectIDs.isEmpty else {
                errorMessage = "No artworks found for '\(query)'. Try a different query."
                isLoading = false
                return
            }
            
            let firstBatch = Array(allObjectIDs.prefix(pageSize))
            currentOffset = firstBatch.count
            
            var fetchedArtworks: [Artwork] = []
            for objectID in firstBatch {
                if let artwork = try? await repository.fetchArtworkDetail(objectID: objectID) {
                    fetchedArtworks.append(artwork)
                }
            }
            
            try? await repository.saveArtworks(fetchedArtworks)
            self.artworks = fetchedArtworks
            
            UserDefaults.standard.set(searchQuery, forKey: "searchQuery")
        } catch {
            errorMessage = "Failed to fetch artworks: \(error.localizedDescription)"
            await loadFromLocalStorage()
        }
        
        isLoading = false
    }
    
    func loadMoreArtworks() async {
        guard !isLoading && !isLoadingMore && hasMorePages else { return }
        
        isLoadingMore = true
        
        let nextBatch = Array(allObjectIDs[currentOffset..<min(currentOffset + pageSize, allObjectIDs.count)])
        currentOffset += nextBatch.count
        
        var fetchedArtworks: [Artwork] = []
        for objectID in nextBatch {
            if let artwork = try? await repository.fetchArtworkDetail(objectID: objectID) {
                fetchedArtworks.append(artwork)
            }
        }
        
        try? await repository.saveArtworks(fetchedArtworks)
        self.artworks.append(contentsOf: fetchedArtworks)
        
        isLoadingMore = false
    }
    
    func loadFromLocalStorage() async {
        isOffline = true
        
        do {
            let localArtworks = try await repository.loadLocalArtworks()
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
    
    func toggleFilterFavorites() {
        filterFavorites.toggle()
        UserDefaults.standard.set(filterFavorites, forKey: "filterFavorites")
    }
    
    func toggleFavorite(for artwork: Artwork) async {
        artwork.isFavorite.toggle()
        try? await repository.updateFavorite(artworkId: artwork.id, isFavorite: artwork.isFavorite)
    }
}
