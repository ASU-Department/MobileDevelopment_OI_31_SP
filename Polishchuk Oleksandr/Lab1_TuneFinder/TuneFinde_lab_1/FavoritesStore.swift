import Foundation

final class FavoritesStore {
    private let key = "favorite_songs_v1"
    
    func load() -> [Song] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Song].self, from: data)) ?? []
    }
    
    func save(_ songs: [Song]) {
        let data = try? JSONEncoder().encode(songs)
        UserDefaults.standard.set(data, forKey: key)
    }
}
