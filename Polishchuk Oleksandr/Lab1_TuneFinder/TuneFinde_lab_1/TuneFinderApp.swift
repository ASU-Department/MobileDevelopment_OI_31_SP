import SwiftUI
import SwiftData

@main
struct TuneFinderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            SongEntity.self,
            FavoriteSongEntity.self
        ])
    }
}
