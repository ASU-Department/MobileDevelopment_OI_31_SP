import Foundation
import SwiftData

actor FavoritesStoreActor {

    static let shared = FavoritesStoreActor()

    private let container: ModelContainer

    // Default init: реальний контейнер
    private init() {
        do {
            container = try ModelContainer(for: FavoriteSongEntity.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    // Test init: in-memory контейнер
    init(testContainer: ModelContainer) {
        self.container = testContainer
    }

    private var context: ModelContext { ModelContext(container) }

    // MARK: - CRUD
    func fetchAll() throws -> [FavoriteSongEntity] {
        // ✅ явний тип у keyPath
        let descriptor = FetchDescriptor<FavoriteSongEntity>(
            sortBy: [SortDescriptor(\FavoriteSongEntity.addedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func find(byID id: Int) throws -> FavoriteSongEntity? {
        let predicate = #Predicate<FavoriteSongEntity> { entity in
            entity.id == id
        }
        let descriptor = FetchDescriptor<FavoriteSongEntity>(predicate: predicate)
        return try context.fetch(descriptor).first
    }

    func add(from song: Song) throws {
        let songId = song.id // (прибере попередження про main-actor, якщо воно є)
        if try find(byID: songId) != nil { return }

        let entity = FavoriteSongEntity(from: song)
        context.insert(entity)
        try context.save()
    }

    func remove(id: Int) throws {
        guard let entity = try find(byID: id) else { return }
        context.delete(entity)
        try context.save()
    }

    func removeAll() throws {
        let all = try fetchAll()
        for item in all { context.delete(item) }
        try context.save()
    }
}
