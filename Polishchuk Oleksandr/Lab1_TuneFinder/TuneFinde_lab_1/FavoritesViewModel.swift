import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var items: [Song] = []
    
    private let store = FavoritesStore()
    
    init() {
        items = store.load()
    }
    
    func isFavorite(_ song: Song) -> Bool {
        items.contains(song)
    }
    
    func toggle(_ song: Song) {
        if let idx = items.firstIndex(of: song) {
            items.remove(at: idx)
        } else {
            items.insert(song, at: 0)
        }
        store.save(items)
    }
    
    func remove(_ song: Song) {
        items.removeAll { $0 == song }
        store.save(items)
    }
    
    func clearAll() {
        items.removeAll()
        store.save(items)
    }
}
	
