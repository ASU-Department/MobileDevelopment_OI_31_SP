import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    @StateObject private var player: AudioPlayerManager
    @State private var showErrorAlert = false

    init(
        viewModel: FavoritesViewModel,
        player: AudioPlayerManager = AudioPlayerManager()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _player = StateObject(wrappedValue: player)
    }

    var body: some View {
        content
            .navigationTitle("Favorites")
            .toolbar {
                if !viewModel.items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear All") {
                            viewModel.clearAll()
                            player.stop()
                        }
                        .accessibilityIdentifier("clearAllFavoritesButton")
                    }
                }
            }
            .onChange(of: viewModel.errorMessage) { _, newValue in
                showErrorAlert = newValue != nil
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { showErrorAlert = false }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading favorites...")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else if viewModel.items.isEmpty {
            VStack(spacing: 12) {
                Text("No favorites yet")
                    .font(.headline)
                Text("Tap ♥ on songs in the search tab to save them here.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityIdentifier("favoritesEmptyState")
        } else {
            List {
                ForEach(viewModel.items) { song in
                    let isPlaying = player.currentlyPlayingId == song.id

                    NavigationLink {
                        TrackDetailView(
                            song: song,
                            isFavorite: .constant(true),
                            player: player,
                            onPlayTap: { togglePlay(song) }
                        )
                    } label: {
                        SongRowView(
                            song: song,
                            isFavorite: .constant(true),
                            isPlaying: isPlaying,
                            onPlayTap: { togglePlay(song) }
                        )
                    }
                }
                .onDelete { indexSet in
                    indexSet
                        .map { viewModel.items[$0] }
                        .forEach { viewModel.remove($0) }
                }
            }
            .listStyle(.plain)
            .accessibilityIdentifier("favoritesList")
        }
    }

    private func togglePlay(_ song: Song) {
        if player.currentlyPlayingId == song.id {
            player.stop()
        } else {
            player.playPreview(for: song)
        }
    }
}
