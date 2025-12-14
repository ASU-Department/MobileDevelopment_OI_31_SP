import Foundation
import SwiftData

// MARK: - Repository Protocol

protocol SongsRepositoryProtocol {
    func searchSongs(term: String) async throws -> [Song]

    func loadFavorites() async throws -> [Song]
    func addToFavorites(_ song: Song) async throws
    func removeFromFavorites(_ song: Song) async throws
    func clearFavorites() async throws
}

// MARK: - Concrete Repository

/// Repository – центральний gateway до даних:
/// View / ViewModel не знають нічого про SwiftData чи мережу.
/// Усі виклики до persistence йдуть через FavoritesStoreActor.
final class TuneFinderRepository: SongsRepositoryProtocol {

    static let shared = TuneFinderRepository()

    private let api: ITunesService
    private let favoritesStore: FavoritesStoreActor

    init(
        api: ITunesService = ITunesService(),
        favoritesStore: FavoritesStoreActor = .shared
    ) {
        self.api = api
        self.favoritesStore = favoritesStore
    }

    // MARK: - SongsRepositoryProtocol

    // Мережа – як і раніше
    func searchSongs(term: String) async throws -> [Song] {
        try await api.searchSongs(term: term)
    }

    // Усі операції зі SwiftData – ЧЕРЕЗ actor

    func loadFavorites() async throws -> [Song] {
        let entities = try await favoritesStore.fetchAll()
        return entities.map { $0.toSong() }
    }

    func addToFavorites(_ song: Song) async throws {
        try await favoritesStore.add(from: song)
    }

    func removeFromFavorites(_ song: Song) async throws {
        try await favoritesStore.remove(id: song.id)
    }

    func clearFavorites() async throws {
        try await favoritesStore.removeAll()
    }
}

