import SwiftUI
import Combine

struct SongRowView: View {
    let song: Song
    
    // @Binding (вимога лаби)
    @Binding var isFavorite: Bool
    
    let isPlaying: Bool
    let onPlayTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            
            ArtworkView(urlString: song.artworkUrl100)
            
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
            
            Button(action: onPlayTap) {
                Image(systemName: isPlaying ? "stop.circle" : "play.circle")
                    .font(.title3)
            }
            .buttonStyle(.plain)
            
            Button {
                isFavorite.toggle()  // тригерить parent через binding
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : .gray)
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}
