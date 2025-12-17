import SwiftData

actor FavoriteMovieActor: ModelActor {
    let modelContainer: ModelContainer
    nonisolated let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    
    func toggleFavorite(tmdbId: Int) async throws {
        let all = try modelContext.fetch(FetchDescriptor<FavoriteMovie>())
        if let existing = all.first(where: { $0.tmdbId == tmdbId }) {
            modelContext.delete(existing)
        } else {
            let newFavorite = FavoriteMovie(tmdbId: tmdbId)
            modelContext.insert(newFavorite)
        }
        
        try modelContext.save()
    }
    
    func isFavorite(tmdbId: Int) async throws -> Bool {
        let all = try modelContext.fetch(FetchDescriptor<FavoriteMovie>())
        return all.contains { $0.tmdbId == tmdbId }
    }
    
    func allFavorites() async throws -> [FavoriteMovie] {
        try modelContext.fetch(FetchDescriptor<FavoriteMovie>())
    }
}
