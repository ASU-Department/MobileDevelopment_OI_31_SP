import Foundation
@testable import app

class MockFavoriteRepository: FavoriteRepositoryProtocol {
    var shouldThrowError = false
    var isFavoriteResult = false
    var toggleCalledWith: [Int] = []
    var favoriteIDs: [Int] = []

    func toggleFavorite(for tmdbId: Int) async throws {
        toggleCalledWith.append(tmdbId)
        if shouldThrowError { throw NSError(domain: "Test", code: 1) }
        
        if favoriteIDs.contains(tmdbId) {
            favoriteIDs.removeAll { $0 == tmdbId }
        } else {
            favoriteIDs.append(tmdbId)
        }
    }
    
    func isFavorite(tmdbId: Int) async throws -> Bool {
        if shouldThrowError { throw NSError(domain: "Test", code: 1) }
        return favoriteIDs.contains(tmdbId)
    }
    
    func fetchAllFavoriteIDs() async throws -> [Int] {
        if shouldThrowError { throw NSError(domain: "Test", code: 1) }
        return favoriteIDs
    }
}
