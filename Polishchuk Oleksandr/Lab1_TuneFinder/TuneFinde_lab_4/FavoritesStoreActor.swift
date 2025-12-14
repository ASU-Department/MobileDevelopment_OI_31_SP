import Foundation
import SwiftData

actor FavoritesStoreActor {

    /// Один спільний інстанс на весь застосунок
    static let shared = FavoritesStoreActor()

    private let container: ModelContainer

    private init() {
        do {
            container = try ModelContainer(for: FavoriteSongEntity.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    private var context: ModelContext {
        ModelContext(container)
    }

    // MARK: - CRUD

    /// Повертає всі обрані треки
    func fetchAll() throws -> [FavoriteSongEntity] {
        let descriptor = FetchDescriptor<FavoriteSongEntity>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    /// Знаходить один обраний трек за id
    func find(byID id: Int) throws -> FavoriteSongEntity? {
        let predicate = #Predicate<FavoriteSongEntity> { entity in
            entity.id == id
        }
        let descriptor = FetchDescriptor<FavoriteSongEntity>(predicate: predicate)
        return try context.fetch(descriptor).first
    }

    /// Додає трек до обраних (якщо його ще нема)
    func add(from song: Song) throws {
        if try find(byID: song.id) != nil {
            return // уже в обраних
        }

        let entity = FavoriteSongEntity(from: song)
        context.insert(entity)
        try context.save()
    }

    /// Видаляє трек з обраних
    func remove(id: Int) throws {
        guard let entity = try find(byID: id) else { return }
        context.delete(entity)
        try context.save()
    }

    /// Очищає всі обрані
    func removeAll() throws {
        let all = try fetchAll()
        for item in all {
            context.delete(item)
        }
        try context.save()
    }
}
