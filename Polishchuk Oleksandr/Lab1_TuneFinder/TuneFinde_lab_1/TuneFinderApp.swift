import SwiftUI

@main
struct TuneFinderApp: App {
    @StateObject private var favoritesVM = FavoritesViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesVM)   // ✅ ОЦЕ ГОЛОВНЕ
        }
    }
}
