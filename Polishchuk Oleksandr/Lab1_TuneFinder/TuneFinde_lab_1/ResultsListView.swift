import SwiftUI
import Combine

struct ResultsListView: View {
    let songs: [Song]
    @ObservedObject var favoritesVM: FavoritesViewModel
    @ObservedObject var player: AudioPlayerManager
    
    var body: some View {
        List(songs) { song in
            // @Binding іде в дитину
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
        .listStyle(.plain)
    }
}
