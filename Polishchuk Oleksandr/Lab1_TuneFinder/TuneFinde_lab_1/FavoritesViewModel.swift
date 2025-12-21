import Foundation
import SwiftUI
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published private(set) var items: [Song] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: SongsRepositoryProtocol

    init(repository: SongsRepositoryProtocol = TuneFinderRepository.shared) {
        self.repository = repository

        Task {
            await load()
        }
    }

    func reload() {
        Task { await load() }
    }

    func isFavorite(_ song: Song) -> Bool {
        items.contains { $0.id == song.id }
    }

    func remove(_ song: Song) {
        Task { await removeAsync(song) }
    }

    func clearAll() {
        Task { await clearAllAsync() }
    }

    // MARK: - Private

    private func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let favorites = try await repository.loadFavorites()
            items = favorites
        } catch {
            errorMessage = "Failed to load favorites: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func removeAsync(_ song: Song) async {
        do {
            try await repository.removeFromFavorites(song)
            await load()
        } catch {
            errorMessage = "Failed to remove song: \(error.localizedDescription)"
        }
    }

    private func clearAllAsync() async {
        do {
            try await repository.clearFavorites()
            items = []
        } catch {
            errorMessage = "Failed to clear favorites: \(error.localizedDescription)"
        }
    }
}
