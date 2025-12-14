import Foundation

final class MockSongsRepository: SongsRepositoryProtocol {

    var storedFavorites: [Song] = [
        Song(
            trackId: 1,
            trackName: "Mock Song 1",
            artistName: "Mock Artist",
            artworkUrl100: nil,
            previewUrl: nil,
            collectionName: "Mock Album",
            primaryGenreName: "Pop",
            trackPrice: 0.99,
            currency: "USD"
        ),
        Song(
            trackId: 2,
            trackName: "Mock Song 2",
            artistName: "Another Artist",
            artworkUrl100: nil,
            previewUrl: nil,
            collectionName: "Another Album",
            primaryGenreName: "Rock",
            trackPrice: 1.29,
            currency: "USD"
        )
    ]

    func searchSongs(term: String) async throws -> [Song] {
        // Iмітація пошуку: просто фільтруємо storedFavorites
        if term.isEmpty {
            return []
        }

        return storedFavorites.filter {
            $0.trackName.localizedCaseInsensitiveContains(term)
            || $0.artistName.localizedCaseInsensitiveContains(term)
        }
    }

    func loadFavorites() async throws -> [Song] {
        storedFavorites
    }

    func addToFavorites(_ song: Song) async throws {
        guard !storedFavorites.contains(where: { $0.id == song.id }) else { return }
        storedFavorites.append(song)
    }

    func removeFromFavorites(_ song: Song) async throws {
        storedFavorites.removeAll { $0.id == song.id }
    }

    func clearFavorites() async throws {
        storedFavorites.removeAll()
    }
}

