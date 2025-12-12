import Foundation

protocol FavoriteRepositoryProtocol {
    func toggleFavorite(for tmdbId: Int) async throws
    func isFavorite(tmdbId: Int) async throws -> Bool
    func fetchAllFavoriteIDs() async throws -> [Int]
}
