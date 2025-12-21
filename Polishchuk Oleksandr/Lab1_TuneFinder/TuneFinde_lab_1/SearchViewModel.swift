import Foundation
import SwiftUI
import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Public state

    @Published var query: String = ""
    @Published private(set) var songs: [Song] = []
    @Published private(set) var favoriteIds: Set<Int> = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    /// Історія останніх пошукових запитів (оновлюється з actor'а)
    @Published private(set) var recentQueries: [String] = []

    // MARK: - Private

    private let repository: SongsRepositoryProtocol
    private let historyActor: SearchHistoryActor

    // MARK: - Init

    init(
        repository: SongsRepositoryProtocol = TuneFinderRepository.shared,
        historyActor: SearchHistoryActor = SearchHistoryActor()
    ) {
        self.repository = repository
        self.historyActor = historyActor

        Task {
            await reloadFavorites()
            await loadHistory()
        }
    }

    // MARK: - API для View

    func performSearch() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            songs = []
            return
        }

        Task {
            // оновлюємо історію ПЕРЕД реальним пошуком
            await historyActor.add(trimmed)
            await loadHistory()
            await search(term: trimmed)
        }
    }

    func filteredSongs(showOnlyFavorites: Bool) -> [Song] {
        guard showOnlyFavorites else { return songs }
        return songs.filter { favoriteIds.contains($0.id) }
    }

    func isFavorite(_ song: Song) -> Bool {
        favoriteIds.contains(song.id)
    }

    func toggleFavorite(_ song: Song) {
        Task {
            await toggleFavoriteAsync(song)
        }
    }

    // Викликається з кнопки на тегах історії
    func selectQueryFromHistory(_ value: String) {
        query = value
        performSearch()
    }

    // MARK: - Private async helpers

    private func search(term: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await repository.searchSongs(term: term)
            songs = result
        } catch {
            errorMessage = "Failed to search: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func toggleFavoriteAsync(_ song: Song) async {
        do {
            if favoriteIds.contains(song.id) {
                try await repository.removeFromFavorites(song)
            } else {
                try await repository.addToFavorites(song)
            }
            await reloadFavorites()
        } catch {
            errorMessage = "Failed to update favorites: \(error.localizedDescription)"
        }
    }

    private func reloadFavorites() async {
        do {
            let favorites = try await repository.loadFavorites()
            favoriteIds = Set(favorites.map { $0.id })
        } catch {
            errorMessage = "Failed to load favorites: \(error.localizedDescription)"
        }
    }

    private func loadHistory() async {
        let history = await historyActor.all()
        recentQueries = history
    }
}
