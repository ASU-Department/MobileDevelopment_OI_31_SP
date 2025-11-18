import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject private var data: AppDataStore
    
    // MARK: - Application State
    @State private var favoriteTeams: Set<Team> = FavoriteStore.shared.load()
    @State private var showLiveOnly: Bool = true
    @State private var query: String = ""
    @State private var showFavoritesManager: Bool = false
    
    @State private var timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    // MARK: - Filtered games
    private var filteredGames: [Game] {
        data.games.filter { g in
            let passesLive = showLiveOnly ? g.isLive : true
            let passesQuery =
                query.isEmpty ||
                g.home.name.localizedCaseInsensitiveContains(query) ||
                g.home.city.localizedCaseInsensitiveContains(query) ||
                g.away.name.localizedCaseInsensitiveContains(query) ||
                g.away.city.localizedCaseInsensitiveContains(query)
            return passesLive && passesQuery
        }
    }
    
    private var sectionTitle: String {
        showLiveOnly ? "Live Games" : "Games"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                if data.isLoading {
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("Loading latest games...")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }
                
                if let error = data.lastError {
                    Text("Failed to refresh from network: \(error)")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                }
                
                HStack {
                    Toggle(isOn: $showLiveOnly) {
                        Text("Live only")
                    }
                    .toggleStyle(SwitchToggleStyle())
                }
                .padding(.horizontal)
                
                TextField("Search teams or cities", text: $query)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                List {
                    Section(header: Text("Favorites")) {
                        if favoriteTeams.isEmpty {
                            Text("No favorites yet. Tap “Manage Favorites” to add.")
                                .foregroundStyle(.secondary)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(Array(favoriteTeams), id: \.self) { team in
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

                    // Games Section
                    Section(header: Text(sectionTitle)) {
                        if filteredGames.isEmpty {
                            Text("No games match the current filters.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(filteredGames) { game in
                                NavigationLink {
                                    GameDetailView(
                                        game: game,
                                        isFavoriteHome: favoriteTeams.contains(game.home),
                                        isFavoriteAway: favoriteTeams.contains(game.away)
                                    )
                                } label: {
                                    GameRow(
                                        game: game,
                                        highlight: favoriteTeams.contains(game.home) || favoriteTeams.contains(game.away)
                                    )
                                }
                                .accessibilityIdentifier("gameRow_\(game.home.short)_\(game.away.short)")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("SportsHub")
            .toolbar {
                NavigationLink {
                    TeamsDirectoryView(allTeams: data.allTeams)
                } label: {
                    Label("Teams", systemImage: "list.bullet.rectangle")
                }
            }
            .sheet(isPresented: $showFavoritesManager) {
                NavigationStack {
                    FavoritesPicker(
                        favoriteTeams: $favoriteTeams,
                        allTeams: data.allTeams
                    )
                }
            }
        }
        .onChange(of: favoriteTeams) { _, newValue in
            FavoriteStore.shared.save(newValue)
        }
        .onReceive(timer) { _ in
            data.tickLiveScores()
        }
        // MARK: Trigger initial network fetch
        .task {
            await data.refreshFromNetwork()
        }
    }
}

#Preview {
    // im using this to mock data load in preview,
    // since i cannot build app on my machine
    let store = AppDataStore()
    store.loadMockData()
    return ContentView()
        .environmentObject(store)
}
