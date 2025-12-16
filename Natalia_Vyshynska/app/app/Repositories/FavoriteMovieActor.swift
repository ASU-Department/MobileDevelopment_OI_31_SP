import SwiftData

actor FavoriteMovieActor {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func toggleFavorite(tmdbId: Int) async throws {
        if let existing = try await fetchFavorite(tmdbId: tmdbId) {
            modelContext.delete(existing)
        } else {
            let favorite = FavoriteMovie(tmdbId: tmdbId)
            modelContext.insert(favorite)
        }
        try modelContext.save()
    }
    
    func isFavorite(tmdbId: Int) async throws -> Bool {
        try await fetchFavorite(tmdbId: tmdbId) != nil
    }
    
    func fetchFavorite(tmdbId: Int) async throws -> FavoriteMovie? {
        let all = try modelContext.fetch(FetchDescriptor<FavoriteMovie>())
        return all.first { $0.tmdbId == tmdbId }
    }
    
    func allFavorites() async throws -> [FavoriteMovie] {
        try modelContext.fetch(FetchDescriptor<FavoriteMovie>())
    }
}
