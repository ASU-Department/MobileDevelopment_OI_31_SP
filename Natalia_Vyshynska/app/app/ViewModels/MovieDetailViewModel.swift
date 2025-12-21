import Foundation
import SwiftUI

@Observable
final class MovieDetailViewModel {
    private let movie: TMDBMovie
    private let favoriteRepository: FavoriteRepositoryProtocol
    
    var isFavorite: Bool = false
    
    init(movie: TMDBMovie, favoriteRepository: FavoriteRepositoryProtocol) {
        self.movie = movie
        self.favoriteRepository = favoriteRepository
        Task {
            await loadFavoriteStatus()
        }
    }
    
    
    var title: String {
        movie.title
    }
    
    var overview: String {
        movie.overview ?? "Немає опису"
    }
    
    var posterURL: URL? {
        movie.posterURL
    }
    
    func toggleFavorite() {
        Task {
            do {
                try await favoriteRepository.toggleFavorite(for: movie.id)
                let newStatus = try await favoriteRepository.isFavorite(tmdbId: movie.id)
                await MainActor.run {
                    self.isFavorite = newStatus
                }
            } catch {
                print("Toggle favorite failed: \(error)")
            }
        }
    }
    
    
    private func loadFavoriteStatus() async {
        do {
            let status = try await favoriteRepository.isFavorite(tmdbId: movie.id)
            await MainActor.run {
                self.isFavorite = status
            }
        } catch {
            print("Failed to load favorite status: \(error)")
        }
    }
}
