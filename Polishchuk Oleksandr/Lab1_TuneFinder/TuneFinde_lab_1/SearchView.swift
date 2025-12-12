import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var player = AudioPlayerManager()

    /// простий стан у UserDefaults (вимога лаби)
    @AppStorage("showOnlyFavoritesInSearch") private var showOnlyFavorites: Bool = false

    @Query(sort: \FavoriteSongEntity.addedAt, order: .reverse)
    private var favoriteEntities: [FavoriteSongEntity]

    // Локальний стан для миттєвого оновлення сердечок
    @State private var favoriteIds: Set<Int> = []

    @State private var showErrorAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            searchField

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding(.top, 8)
            } else if viewModel.songs.isEmpty {
                EmptyStateView(
                    message: viewModel.isOfflineMode
                    ? "Offline. Showing last saved results (if any)."
                    : "Start typing to search for songs."
                )
                .padding(.top, 24)
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                resultsList
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Spacer()    // 🔹 «приклеює» все до верху
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // додатково фіксує вирівнювання
        .navigationTitle("TuneFinder")
        .toolbar {
            toolbarContent
        }
        .onAppear {
            if viewModel.songs.isEmpty {
                viewModel.loadCachedSongs(from: modelContext)
            }
            syncFavoriteIdsWithQuery()
        }
        .onChange(of: favoriteEntities) { _, _ in
            // якщо SwiftData оновилася ззовні – підтягнути зміни в локальний стан
            syncFavoriteIdsWithQuery()
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showErrorAlert = newValue != nil
        }
        .refreshable {
            await viewModel.search(using: modelContext)
        }
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            if viewModel.isOfflineMode {
                Text("Offline mode: showing cached results")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }

            if let date = viewModel.lastUpdateDate {
                Text("Last update: \(date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var searchField: some View {
        HStack {
            TextField("Search songs or artists", text: $viewModel.searchTerm)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit {
                    Task {
                        await viewModel.search(using: modelContext)
                    }
                }
                .onChange(of: viewModel.searchTerm) { _, newValue in
                    let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.isEmpty {
                        // коли поле пошуку очистили – прибираємо результати
                        viewModel.songs = []
                        viewModel.isOfflineMode = false
                        viewModel.errorMessage = nil
                    }
                }

            Button {
                Task {
                    await viewModel.search(using: modelContext)
                }
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.bordered)
        }
    }

    private var resultsList: some View {
        let displayedSongs: [Song] = {
            if showOnlyFavorites {
                return viewModel.songs.filter { favoriteIds.contains($0.id) }
            } else {
                return viewModel.songs
            }
        }()

        return ResultsListView(
            songs: displayedSongs,
            isFavorite: { song in
                favoriteIds.contains(song.id)
            },
            toggleFavorite: { song in
                toggleFavorite(song)
            },
            player: player
        )
    }

    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Toggle(isOn: $showOnlyFavorites) {
                Image(systemName: "heart.fill")
            }
            .toggleStyle(.button)
            .help("Show only favorite songs in search results")
        }
    }

    // MARK: - Favorites (SwiftData + локальний стан)

    private func syncFavoriteIdsWithQuery() {
        favoriteIds = Set(favoriteEntities.map { $0.id })
    }

    private func toggleFavorite(_ song: Song) {
        // 1. миттєво оновлюємо локальний стан для UI
        if favoriteIds.contains(song.id) {
            favoriteIds.remove(song.id)
        } else {
            favoriteIds.insert(song.id)
        }

        // 2. синхронно оновлюємо SwiftData (реальне сховище)
        let descriptor = FetchDescriptor<FavoriteSongEntity>(
            predicate: #Predicate { $0.id == song.id }
        )

        if let entities = try? modelContext.fetch(descriptor),
           let entity = entities.first {
            // якщо вже в улюблених — прибираємо
            modelContext.delete(entity)
        } else {
            // інакше додаємо
            _ = FavoriteSongEntity(from: song)
        }

        try? modelContext.save()
    }
}
