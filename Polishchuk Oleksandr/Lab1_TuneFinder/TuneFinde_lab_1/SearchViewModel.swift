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
    @Published private(set) var recentQueries: [String] = []

    // MARK: - Private
    private let repository: SongsRepositoryProtocol
    private let historyActor: SearchHistoryActor
    private let autoLoadOnInit: Bool

    // MARK: - Init
    init(
        repository: SongsRepositoryProtocol = TuneFinderRepository.shared,
        historyActor: SearchHistoryActor = SearchHistoryActor(),
        autoLoadOnInit: Bool = true
    ) {
        self.repository = repository
        self.historyActor = historyActor
        self.autoLoadOnInit = autoLoadOnInit

        if autoLoadOnInit {
            Task {
                await reloadFavorites()
                await loadHistory()
            }
        }
    }

    // MARK: - API (sync wrappers for Views)
    func performSearch() {
        Task { await performSearchAsync() }
    }

    func toggleFavorite(_ song: Song) {
        Task { await toggleFavoriteAsync(song) }
    }

    func selectQueryFromHistory(_ value: String) {
        query = value
        performSearch()
    }

    // MARK: - API (async for Unit Tests)
    func performSearchAsync() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            songs = []
            errorMessage = nil
            return
        }

        await historyActor.add(trimmed)
        await loadHistory()
        await search(term: trimmed)
    }

    func search(term: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let result = try await repository.searchSongs(term: term)
            songs = result
        } catch {
            errorMessage = "Failed to search: \(error.localizedDescription)"
        }
    }

    func toggleFavoriteAsync(_ song: Song) async {
        errorMessage = nil
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

    func reloadFavorites() async {
        do {
            let favorites = try await repository.loadFavorites()
            favoriteIds = Set(favorites.map { $0.id })
        } catch {
            errorMessage = "Failed to load favorites: \(error.localizedDescription)"
        }
    }

    func loadHistory() async {
        recentQueries = await historyActor.all()
    }

    // MARK: - Pure logic helpers (easy to test)
    func filteredSongs(showOnlyFavorites: Bool) -> [Song] {
        guard showOnlyFavorites else { return songs }
        return songs.filter { favoriteIds.contains($0.id) }
    }

    func isFavorite(_ song: Song) -> Bool {
        favoriteIds.contains(song.id)
    }
}

