import SwiftUI
import Combine

struct FavoritesView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @StateObject private var player = AudioPlayerManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                if favoritesVM.items.isEmpty {
                    EmptyStateView(message: "No favorites yet. Tap ♥ on songs.")
                } else {
                    List {
                        ForEach(favoritesVM.items) { song in
                            SongRowView(
                                song: song,
                                isFavorite: Binding(
                                    get: { favoritesVM.isFavorite(song) },
                                    set: { _ in favoritesVM.toggle(song) }
                                ),
                                isPlaying: player.currentlyPlayingId == song.id,
                                onPlayTap: { player.playPreview(for: song) }
                            )
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { favoritesVM.remove(favoritesVM.items[$0]) }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                if !favoritesVM.items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear All") {
                            favoritesVM.clearAll()
                            player.stop()
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
}
