import Foundation
import SwiftUI
import SwiftData

@Observable
final class MovieViewModel {
    var movies: [TMDBMovie] = []
    var isLoading = false
    var errorMessage: String?
    
    private let service = TMDBService()
    private let modelContext: ModelContext
    private let lastUpdateKey = "lastMoviesUpdate"
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchFavoritesFromDB()
    }
    
    func loadMovies(forceRefresh: Bool = false) async {
        isLoading = true
        errorMessage = nil
        
        if !forceRefresh,
           let lastDate = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date,
           Date().timeIntervalSince(lastDate) < 600 {
            isLoading = false
            return
        }
        
        do {
            movies = try await service.fetchPopularMovies()
            UserDefaults.standard.set(Date(), forKey: lastUpdateKey)
        } catch {
            errorMessage = "Немає інтернету або сервер впав \n\(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func refresh() async {
        await loadMovies(forceRefresh: true)
    }
    
    // Favorites (SwiftData)
    func toggleFavorite(_ movie: TMDBMovie) {
        if let existing = favoriteMovie(for: movie.id) {
            modelContext.delete(existing)
        } else {
            let fav = FavoriteMovie(tmdbId: movie.id)
            modelContext.insert(fav)
        }
        try? modelContext.save()
    }
    
    func isFavorite(_ movie: TMDBMovie) -> Bool {
        favoriteMovie(for: movie.id) != nil
    }
    
    func favoriteMovie(for tmdbId: Int) -> FavoriteMovie? {
        let request = FetchDescriptor<FavoriteMovie>(predicate: #Predicate { $0.tmdbId == tmdbId })
        return try? modelContext.fetch(request).first
    }
    
    private func fetchFavoritesFromDB() {
        // future func
    }
}
