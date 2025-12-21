import Testing
import SwiftData
@testable import TuneFinder

struct Actors_SwiftTesting {

    @Test
    func searchHistoryKeepsUniqueAndMax10() async {
        let actor = SearchHistoryActor()

        await actor.add("Hello")
        await actor.add("hello") // duplicate (case-insensitive) -> should move to top, not duplicate
        await actor.add("World")

        let all1 = await actor.all()
        #expect(all1.count == 2)
        #expect(all1.first == "World")

        // Add 15 items -> must keep 10
        for i in 0..<15 {
            await actor.add("Q\(i)")
        }
        let all2 = await actor.all()
        #expect(all2.count == 10)
        #expect(all2.first == "Q14")
    }

    @Test
    func favoritesStoreActorIsThreadSafeAndConsistent() async throws {
        // In-memory SwiftData container
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: FavoriteSongEntity.self, configurations: config)
        let store = FavoritesStoreActor(testContainer: container)

        let song = Song(
            trackId: 999,
            trackName: "Test Song",
            artistName: "Tester",
            artworkUrl100: nil,
            previewUrl: nil,
            collectionName: nil,
            primaryGenreName: nil,
            trackPrice: nil,
            currency: nil
        )

        // Concurrent adds (should end with 1 item)
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<20 {
                group.addTask {
                    try? await store.add(from: song)
                }
            }
        }

        let all = try await store.fetchAll()
        #expect(all.count == 1)

        // remove
        try await store.remove(id: song.id)
        let afterRemove = try await store.fetchAll()
        #expect(afterRemove.isEmpty)
    }
}
