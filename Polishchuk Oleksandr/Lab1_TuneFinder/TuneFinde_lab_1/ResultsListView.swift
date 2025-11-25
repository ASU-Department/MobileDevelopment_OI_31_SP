import SwiftUI
import Combine

struct ResultsListView: View {
    let songs: [Song]
    @ObservedObject var favoritesVM: FavoritesViewModel
    @ObservedObject var player: AudioPlayerManager

    var body: some View {
        List(songs) { song in

            // Один і той самий Binding на фаворит,
            // щоб працював і в рядку, і в деталях
            let favBinding = Binding<Bool>(
                get: { favoritesVM.isFavorite(song) },
                set: { _ in favoritesVM.toggle(song) }
            )

            NavigationLink {
                TrackDetailView(
                    song: song,
                    isFavorite: favBinding,
                    player: player,
                    onPlayTap: { player.playPreview(for: song) }
                )
            } label: {
                SongRowView(
                    song: song,
                    isFavorite: favBinding,
                    isPlaying: player.currentlyPlayingId == song.id,
                    onPlayTap: { player.playPreview(for: song) }
                )
            }
        }
        .listStyle(.plain)
    }
}

