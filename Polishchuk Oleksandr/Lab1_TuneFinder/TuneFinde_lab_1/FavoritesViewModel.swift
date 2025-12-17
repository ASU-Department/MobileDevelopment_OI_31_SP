import Foundation
import SwiftData
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var items: [Song] = []

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        reload()
    }

    func reload() {
        let descriptor = FetchDescriptor<FavoriteSongEntity>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )

        if let entities = try? context.fetch(descriptor) {
            self.items = entities.map { $0.toSong() }
        }
    }

    func isFavorite(_ song: Song) -> Bool {
        items.contains { $0.id == song.id }
    }

    func toggle(_ song: Song) {
        if isFavorite(song) {
            remove(song)
        } else {
            add(song)
        }
    }

    func add(_ song: Song) {
        _ = FavoriteSongEntity(from: song)
        try? context.save()
        reload()
    }

    func remove(_ song: Song) {
        let descriptor = FetchDescriptor<FavoriteSongEntity>(
            predicate: #Predicate { $0.id == song.id }
        )

        if let entities = try? context.fetch(descriptor) {
            for e in entities {
                context.delete(e)
            }
            try? context.save()
            reload()
        }
    }

    func clearAll() {
        let descriptor = FetchDescriptor<FavoriteSongEntity>()
        if let entities = try? context.fetch(descriptor) {
            for e in entities {
                context.delete(e)
            }
            try? context.save()
            reload()
        }
    }
}

