import Foundation
import SwiftUI
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published private(set) var items: [Song] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: SongsRepositoryProtocol
    private let autoLoadOnInit: Bool

    init(
        repository: SongsRepositoryProtocol = TuneFinderRepository.shared,
        autoLoadOnInit: Bool = true
    ) {
        self.repository = repository
        self.autoLoadOnInit = autoLoadOnInit

        if autoLoadOnInit {
            Task { await load() }
        }
    }

    // MARK: - Sync wrappers for Views
    func reload() {
        Task { await load() }
    }

    func remove(_ song: Song) {
        Task { await removeAsync(song) }
    }

    func clearAll() {
        Task { await clearAllAsync() }
    }

    // MARK: - Async for Unit Tests
    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let favorites = try await repository.loadFavorites()
            items = favorites
        } catch {
            errorMessage = "Failed to load favorites: \(error.localizedDescription)"
        }
    }

    func removeAsync(_ song: Song) async {
        do {
            try await repository.removeFromFavorites(song)
            await load()
        } catch {
            errorMessage = "Failed to remove song: \(error.localizedDescription)"
        }
    }

    func clearAllAsync() async {
        do {
            try await repository.clearFavorites()
            items = []
        } catch {
            errorMessage = "Failed to clear favorites: \(error.localizedDescription)"
        }
    }

    // MARK: - Pure logic
    func isFavorite(_ song: Song) -> Bool {
        items.contains { $0.id == song.id }
    }
}
