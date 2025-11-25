import SwiftUI

struct TrackDetailView: View {
    let song: Song

    // той самий Binding, що передається з ResultsListView
    @Binding var isFavorite: Bool

    // щоб бачити прогрес/час/гру
    @ObservedObject var player: AudioPlayerManager

    // колбек програвання (твоя логіка play/stop)
    let onPlayTap: () -> Void

    // UIKit slider state (UIViewRepresentable)
    @State private var volume: Float = 0.6

    // Share sheet state (UIViewControllerRepresentable)
    @State private var showShare = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Artwork
                ArtworkView(urlString: song.artworkUrl100)
                    .frame(width: 220, height: 220)
                    .padding(.top, 8)

                // Title / artist / album
                VStack(spacing: 6) {
                    Text(song.trackName)
                        .font(.title2).bold()
                        .multilineTextAlignment(.center)

                    Text(song.artistName)
                        .foregroundStyle(.secondary)

                    if let album = song.collectionName {
                        Text(album)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // --- UIKit view via UIViewRepresentable (Lab2 requirement) ---
                VStack(alignment: .leading, spacing: 8) {
                    Text("Preview volume")
                        .font(.headline)

                    UIKitSliderView(value: $volume)
                        .frame(height: 32)

                    Text(String(format: "%.0f%%", volume * 100))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // --- Timeline / progress (SwiftUI slider) ---
                VStack(alignment: .leading, spacing: 8) {
                    Text("Preview progress")
                        .font(.headline)

                    Slider(
                        value: Binding(
                            get: { player.progress },
                            set: { newVal in
                                player.seek(to: newVal)
                            }
                        ),
                        in: 0...1
                    )

                    HStack {
                        Text(formatTime(player.currentTime))
                        Spacer()
                        Text(formatTime(player.duration))
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(.gray.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Buttons row
                HStack(spacing: 12) {
                    Button(action: onPlayTap) {
                        Label(
                            player.currentlyPlayingId == song.id ? "Stop" : "Preview",
                            systemImage:
                                player.currentlyPlayingId == song.id
                                ? "stop.circle.fill"
                                : "play.circle.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .gray)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        showShare = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 6)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Track Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShare) {
            ShareSheet(items: ["\(song.trackName) — \(song.artistName)"])
        }
    }

    // MARK: - Helpers

    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite else { return "0:00" }
        let s = Int(seconds)
        let m = s / 60
        let r = s % 60
        return String(format: "%d:%02d", m, r)
    }
}
