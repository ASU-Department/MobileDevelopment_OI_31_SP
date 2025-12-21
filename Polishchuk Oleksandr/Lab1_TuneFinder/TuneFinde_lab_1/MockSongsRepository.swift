import Foundation

final class MockSongsRepository: SongsRepositoryProtocol {

    private var favorites: [Song] = []

    func searchSongs(term: String) async throws -> [Song] {
        // ✅ завжди повертаємо результат для UI tests
        return [
            Song(
                trackId: 1,
                trackName: "Mock Song 1",
                artistName: "Mock Artist",
                artworkUrl100: nil,
                previewUrl: nil,
                collectionName: "Mock Album",
                primaryGenreName: nil,
                trackPrice: nil,
                currency: nil
            ),
            Song(
                trackId: 2,
                trackName: "Mock Song 2",
                artistName: "Mock Artist",
                artworkUrl100: nil,
                previewUrl: nil,
                collectionName: "Mock Album",
                primaryGenreName: nil,
                trackPrice: nil,
                currency: nil
            )
        ]
    }

    func loadFavorites() async throws -> [Song] {
        favorites
    }

    func addToFavorites(_ song: Song) async throws {
        if favorites.contains(where: { $0.id == song.id }) { return }
        favorites.append(song)
    }

    func removeFromFavorites(_ song: Song) async throws {
        favorites.removeAll { $0.id == song.id }
    }

    func clearFavorites() async throws {
        favorites.removeAll()
    }
}
