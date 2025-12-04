import SwiftUI
import Combine

struct SongRowView: View {
    let song: Song
    // тепер справжній Binding – його значення приходить з вищого рівня (SwiftData)
    @Binding var isFavorite: Bool

    let isPlaying: Bool
    let onPlayTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ArtworkView(url: song.artworkUrl100)

            VStack(alignment: .leading, spacing: 4) {
                Text(song.trackName)
                    .font(.headline)
                    .lineLimit(1)

                Text(song.artistName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if let album = song.collectionName {
                    Text(album)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // play / pause
            Button(action: onPlayTap) {
                Image(systemName: isPlaying ? "stop.circle" : "play.circle")
                    .font(.title3)
            }
            .buttonStyle(.plain)

            // ♥ обране
            Button {
                isFavorite.toggle()   // викликає setter Binding'a → SwiftData оновиться вище
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : .secondary)
            }
            .buttonStyle(.plain)
        }
    }
}


