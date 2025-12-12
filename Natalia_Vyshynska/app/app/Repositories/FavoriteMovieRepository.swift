@MainActor
final class FavoriteMovieRepository: FavoriteRepositoryProtocol {
    private let actor: FavoriteMovieActor
    
    init(actor: FavoriteMovieActor) {
        self.actor = actor
    }
    
    func toggleFavorite(for tmdbId: Int) async throws {
        try await actor.toggleFavorite(tmdbId: tmdbId)
    }
    
    func isFavorite(tmdbId: Int) async throws -> Bool {
        try await actor.isFavorite(tmdbId: tmdbId)
    }
    
    func fetchAllFavoriteIDs() async throws -> [Int] {
        try await actor.allFavorites().map { $0.tmdbId }
    }
}
