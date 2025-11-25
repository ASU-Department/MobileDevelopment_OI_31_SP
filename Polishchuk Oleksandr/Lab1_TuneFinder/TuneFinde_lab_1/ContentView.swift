import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var favoritesVM = FavoritesViewModel()

    var body: some View {
        SearchView()
            .environmentObject(favoritesVM)
    }
}

