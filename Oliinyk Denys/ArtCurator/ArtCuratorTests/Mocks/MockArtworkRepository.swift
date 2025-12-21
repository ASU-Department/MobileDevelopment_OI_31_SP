import Foundation
@testable import ArtCurator

@MainActor
class MockArtworkRepository: ArtworkRepositoryProtocol {
    var searchResult: Result<[Int], Error> = .success([])
    var fetchDetailResult: Result<Artwork?, Error> = .success(nil)
    var loadLocalResult: Result<[Artwork], Error> = .success([])
    var saveArtworksError: Error?
    var updateFavoriteError: Error?
    
    var searchCallCount = 0
    var fetchDetailCallCount = 0
    var loadLocalCallCount = 0
    var saveArtworksCallCount = 0
    var updateFavoriteCallCount = 0
    
    var lastSearchQuery: String?
    var lastFetchedObjectID: Int?
    var lastSavedArtworks: [Artwork]?
    var lastUpdatedArtworkId: Int?
    var lastUpdatedFavoriteStatus: Bool?
    
    var fetchDetailDelay: TimeInterval = 0
    var searchDelay: TimeInterval = 0
    
    func searchArtworks(query: String) async throws -> [Int] {
        searchCallCount += 1
        lastSearchQuery = query
        
        if searchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(searchDelay * 1_000_000_000))
        }
        
        switch searchResult {
        case .success(let ids):
            return ids
        case .failure(let error):
            throw error
        }
    }
    
    func fetchArtworkDetail(objectID: Int) async throws -> Artwork? {
        fetchDetailCallCount += 1
        lastFetchedObjectID = objectID
        
        if fetchDetailDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(fetchDetailDelay * 1_000_000_000))
        }
        
        switch fetchDetailResult {
        case .success(let artwork):
            return artwork
        case .failure(let error):
            throw error
        }
    }
    
    func loadLocalArtworks() async throws -> [Artwork] {
        loadLocalCallCount += 1
        
        switch loadLocalResult {
        case .success(let artworks):
            return artworks
        case .failure(let error):
            throw error
        }
    }
    
    func saveArtworks(_ artworks: [Artwork]) async throws {
        saveArtworksCallCount += 1
        lastSavedArtworks = artworks
        
        if let error = saveArtworksError {
            throw error
        }
    }
    
    func updateFavorite(artworkId: Int, isFavorite: Bool) async throws {
        updateFavoriteCallCount += 1
        lastUpdatedArtworkId = artworkId
        lastUpdatedFavoriteStatus = isFavorite
        
        if let error = updateFavoriteError {
            throw error
        }
    }
    
    func reset() {
        searchResult = .success([])
        fetchDetailResult = .success(nil)
        loadLocalResult = .success([])
        saveArtworksError = nil
        updateFavoriteError = nil
        
        searchCallCount = 0
        fetchDetailCallCount = 0
        loadLocalCallCount = 0
        saveArtworksCallCount = 0
        updateFavoriteCallCount = 0
        
        lastSearchQuery = nil
        lastFetchedObjectID = nil
        lastSavedArtworks = nil
        lastUpdatedArtworkId = nil
        lastUpdatedFavoriteStatus = nil
        
        fetchDetailDelay = 0
        searchDelay = 0
    }
}

enum MockError: Error, Equatable {
    case networkError
    case decodingError
    case databaseError
    case timeout
    case notFound
}
