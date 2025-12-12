import SwiftUI
import SwiftData
import Combine

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModelHolder = FavoritesViewModelHolder()
    @StateObject private var player = AudioPlayerManager()

    var body: some View {
        Group {
            if let vm = viewModelHolder.viewModel {
                content(using: vm)
            } else {
                ProgressView("Loading favorites...")
            }
        }
        .onAppear {
            if viewModelHolder.viewModel == nil {
                viewModelHolder.viewModel = FavoritesViewModel(context: modelContext)
            } else {
                viewModelHolder.viewModel?.reload()
            }
        }
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear All") {
                    viewModelHolder.viewModel?.clearAll()
                }
                .disabled(viewModelHolder.viewModel?.items.isEmpty ?? true)
            }
        }
    }

    @ViewBuilder
    private func content(using vm: FavoritesViewModel) -> some View {
        if vm.items.isEmpty {
            EmptyStateView(message: "No favorites yet. Tap ♥ on songs to save them.")
                .padding()
        } else {
            List {
                ForEach(vm.items) { song in
                    let favBinding = Binding<Bool>(
                        get: { true },      // у Favorites всі елементи — обрані
                        set: { newValue in
                            if newValue == false {
                                vm.remove(song)
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
                                togglePlay(song)
                            }
                        )
                    } label: {
                        SongRowView(
                            song: song,
                            isFavorite: favBinding,
                            isPlaying: isPlaying,
                            onPlayTap: {
                                togglePlay(song)
                            }
                        )
                    }
                }
                .onDelete { indexSet in
                    indexSet
                        .map { vm.items[$0] }
                        .forEach { vm.remove($0) }
                }
            }
            .listStyle(.plain)
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

/// Хелпер, щоб мати @StateObject, але створювати ViewModel з ModelContext
private final class FavoritesViewModelHolder: ObservableObject {
    @Published var viewModel: FavoritesViewModel?
}
