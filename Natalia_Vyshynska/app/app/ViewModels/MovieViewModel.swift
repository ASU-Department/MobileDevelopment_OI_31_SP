import Foundation
import SwiftUI
import SwiftData

@Observable
final class MovieViewModel {
    var movies: [TMDBMovie] = []
    var isLoading = false
    var errorMessage: String?
    
    var favoriteIDs: Set<Int> = []
    
    internal var tmdbService: TMDBService = TMDBService()
    private let favoriteRepository: FavoriteRepositoryProtocol
    
    private let lastUpdateKey = "lastMoviesUpdate"
    
    init(favoriteRepository: FavoriteRepositoryProtocol) {
        self.favoriteRepository = favoriteRepository
        Task {
            await loadFavorites()
        }
    }
    
    
    func loadMovies(forceRefresh: Bool = false) async {
        isLoading = true
        errorMessage = nil
        
        if !forceRefresh, let lastDate = UserDefaults.standard.object(forKey: lastUpdateKey) as? Date,
           Date().timeIntervalSince(lastDate) < 600 {
            isLoading = false
            return
        }
        
        do {
            movies = try await tmdbService.fetchPopularMovies()
            UserDefaults.standard.set(Date(), forKey: lastUpdateKey)
            await loadFavorites()
        } catch {
            errorMessage = "Немає інтернету або сервер впав \n\(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func refresh() async {
        await loadMovies(forceRefresh: true)
    }
    
    
    func isFavorite(_ movie: TMDBMovie) -> Bool {
        favoriteIDs.contains(movie.id)
    }
    
    
    func toggleFavorite(_ movie: TMDBMovie) {
        Task {
            do {
                try await favoriteRepository.toggleFavorite(for: movie.id)
                // Оновлюємо локальний стан одразу після toggle
                if favoriteIDs.contains(movie.id) {
                    favoriteIDs.remove(movie.id)
                } else {
                    favoriteIDs.insert(movie.id)
                }
            } catch {
                print("Failed to toggle favorite: \(error)")
            }
        }
    }
    
    
    private func loadFavorites() async {
        do {
            let favorites = try await favoriteRepository.fetchAllFavoriteIDs()
            favoriteIDs = Set(favorites)
        } catch {
            print("Failed to load favorites: \(error)")
        }
    }
    private class DummyRepository: FavoriteRepositoryProtocol {
        func toggleFavorite(for tmdbId: Int) async throws {}
        func isFavorite(tmdbId: Int) async throws -> Bool { false }
        func fetchAllFavoriteIDs() async throws -> [Int] { [] }
    }
    
}
