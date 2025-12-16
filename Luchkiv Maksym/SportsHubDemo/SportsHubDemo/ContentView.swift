import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel: GamesViewModel
    @State private var showFavoritesManager = false

    init(viewModel: GamesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 12) {
            if viewModel.isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Updating...")
                            .font(.footnote)

                        if let last = viewModel.lastUpdateDate {
                            Text("Last updated: \(last.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }

            if let error = viewModel.lastError {
                Text("Failed to refresh from network: \(error)")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
            }

            List {
                Section(header: Text("Preferences")) {
                    HStack {
                        Toggle(isOn: Binding(
                            get: { viewModel.showLiveOnly },
                            set: { viewModel.setShowLiveOnly($0) }
                        )) {
                            Text("Live only")
                        }
                        .toggleStyle(SwitchToggleStyle())
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Section(header: Text("Favorites")) {
                    if viewModel.favoriteTeams.isEmpty {
                        Text("No favorites yet. Tap “Manage Favorites” to add.")
                            .foregroundStyle(.secondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Array(viewModel.favoriteTeams), id: \.self) { team in
                                    Label("\(team.short)", systemImage: "star.fill")
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(AppColor.accent.opacity(0.25))
                                        .clipShape(Capsule())
                                        .accessibilityLabel("\(team.city) \(team.name) favorite")
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Button {
                        showFavoritesManager = true
                    } label: {
                        Label("Manage Favorites", systemImage: "star")
                    }
                    .accessibilityIdentifier("manageFavoritesButton")
                }

                Section(header: Text(viewModel.sectionTitle)) {
                    if viewModel.filteredGames.isEmpty {
                        Text("No games match the current filters.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.filteredGames) { game in
                            NavigationLink(
                                value: AppRoute.game(
                                    game,
                                    favorites: .init(
                                        home: viewModel.favoriteTeams.contains(game.home),
                                        away: viewModel.favoriteTeams.contains(game.away)
                                    )
                                )
                            ) {
                                GameRow(
                                    game: game,
                                    highlight: viewModel.favoriteTeams.contains(game.home) || viewModel.favoriteTeams.contains(game.away)
                                )
                            }
                            .accessibilityIdentifier("gameRow_\(game.home.short)_\(game.away.short)")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable {
                await viewModel.refresh()
            }
        }
        .navigationTitle("SportsHub")
        .searchable(text: Binding(
            get: { viewModel.query },
            set: { viewModel.setQuery($0) }
        ), placement: .navigationBarDrawer(displayMode: .automatic))
        .toolbar {
            Button {
                coordinator.showTeamsDirectory(with: viewModel.allTeams)
            } label: {
                Label("Teams", systemImage: "list.bullet.rectangle")
            }
        }
        .sheet(isPresented: $showFavoritesManager) {
            NavigationStack {
                FavoritesPicker(
                    favoriteTeams: Binding(
                        get: { viewModel.favoriteTeams },
                        set: { viewModel.updateFavorites($0) }
                    ),
                    allTeams: viewModel.allTeams
                )
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") { showFavoritesManager = false }
                            .accessibilityIdentifier("favoritesDoneButton")
                    }
                }
            }
        }
        .task {
            await viewModel.loadInitial()
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
    }
}

#Preview {
    NavigationStack {
        ContentView(
            viewModel: GamesViewModel(
                repository: DefaultGamesRepository(container: PreviewContainer.shared)
            )
        )
        .environmentObject(AppCoordinator(container: PreviewContainer.shared))
    }
    .modelContainer(PreviewContainer.shared)
}
