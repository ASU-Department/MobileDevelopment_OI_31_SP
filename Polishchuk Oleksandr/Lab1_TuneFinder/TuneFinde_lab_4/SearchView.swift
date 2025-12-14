import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @StateObject private var player: AudioPlayerManager

    @AppStorage("showOnlyFavoritesInSearch")
    private var showOnlyFavorites: Bool = false

    @State private var showErrorAlert = false

    // DI: ViewModel приходить ззовні (від координатора)
    init(
        viewModel: SearchViewModel,
        player: AudioPlayerManager = AudioPlayerManager()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _player = StateObject(wrappedValue: player)
    }

    var body: some View {
        VStack(spacing: 12) {
            searchBar

            if !viewModel.recentQueries.isEmpty {
                recentQueriesView
            }

            Toggle("Show only favorites", isOn: $showOnlyFavorites)
                .padding(.horizontal)

            content
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showErrorAlert = newValue != nil
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                showErrorAlert = false
            }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }

    // MARK: - Subviews

    private var searchBar: some View {
        HStack {
            TextField("Search songs or artists", text: $viewModel.query)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    viewModel.performSearch()
                }

            Button {
                viewModel.performSearch()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding([.horizontal, .top])
    }

    private var recentQueriesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.recentQueries, id: \.self) { q in
                    Button {
                        viewModel.selectQueryFromHistory(q)
                    } label: {
                        Text(q)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .strokeBorder(.secondary, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            Spacer()
            ProgressView("Searching...")
            Spacer()
        } else {
            let songs = viewModel.filteredSongs(showOnlyFavorites: showOnlyFavorites)

            if songs.isEmpty {
                Spacer()
                Text("Start typing a query to search for tracks.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(songs) { song in
                        let isPlaying = player.currentlyPlayingId == song.id

                        NavigationLink {
                            TrackDetailView(
                                song: song,
                                isFavorite: Binding(
                                    get: { viewModel.isFavorite(song) },
                                    set: { _ in viewModel.toggleFavorite(song) }
                                ),
                                player: player,
                                onPlayTap: {
                                    togglePlay(song)
                                }
                            )
                        } label: {
                            SongRowView(
                                song: song,
                                isFavorite: Binding(
                                    get: { viewModel.isFavorite(song) },
                                    set: { _ in viewModel.toggleFavorite(song) }
                                ),
                                isPlaying: isPlaying,
                                onPlayTap: {
                                    togglePlay(song)
                                }
                            )
                        }
                    }
                }
                .listStyle(.plain)
            }
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
