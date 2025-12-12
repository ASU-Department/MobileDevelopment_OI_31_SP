import SwiftUI

struct ResultsListView: View {
    let songs: [Song]
    let isFavorite: (Song) -> Bool
    let toggleFavorite: (Song) -> Void

    @ObservedObject var player: AudioPlayerManager

    var body: some View {
        List(songs) { song in
            // Binding, який вміє читати статус із SwiftData
            // і при зміні викликати toggleFavorite(song)
            let favBinding = Binding<Bool>(
                get: { isFavorite(song) },
                set: { newValue in
                    if newValue != isFavorite(song) {
                        toggleFavorite(song)
                    }
                }
            )

            let isPlaying = player.currentlyPlayingId == song.id

            NavigationLink {
                TrackDetailView(
                    song: song,
                    isFavorite: favBinding,
                    player: player,
                    onPlayTap: {
                        togglePlay(for: song)
                    }
                )
            } label: {
                SongRowView(
                    song: song,
                    isFavorite: favBinding,
                    isPlaying: isPlaying,
                    onPlayTap: {
                        togglePlay(for: song)
                    }
                )
            }
        }
        .listStyle(.plain)
    }

    private func togglePlay(for song: Song) {
        if player.currentlyPlayingId == song.id {
            player.stop()
        } else {
            player.playPreview(for: song)
        }
    }
}
