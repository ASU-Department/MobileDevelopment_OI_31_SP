import SwiftUI
import SwiftData

@main
struct CineGuideApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: FavoriteMovie.self)
        }
    }
}
