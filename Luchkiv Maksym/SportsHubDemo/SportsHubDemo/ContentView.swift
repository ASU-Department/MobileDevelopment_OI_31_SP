import SwiftUI
import Combine

struct ContentView: View {
    // MARK: - Application State
    @State private var favoriteTeams: Set<Team> = FavoriteStore.shared.load()
    @State private var showLiveOnly: Bool = true
    @State private var query: String = ""
    @State private var showFavoritesManager: Bool = false

    // TODO: change to API calls later
    @State private var games: [Game] = SampleData.games
    private let allTeams: [Team] = SampleData.allTeams
    
    @State private var timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    // MARK: - Filtered games
    private var filteredGames: [Game] {
        games.filter { g in
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
                .listStyle(.insetGrouped)
            }
            .navigationTitle("SportsHub")
            .toolbar {
                NavigationLink {
                    TeamsDirectoryView(allTeams: allTeams)
                } label: {
                    Label("Teams", systemImage: "list.bullet.rectangle")
                }
            }
            .sheet(isPresented: $showFavoritesManager) {
                NavigationStack {
                    FavoritesPicker(
                        favoriteTeams: $favoriteTeams,
                        allTeams: allTeams
                    )
                }
            }
        }
        .onChange(of: favoriteTeams) {
            FavoriteStore.shared.save($0)
        }
        .onReceive(timer) { _ in
            for i in games.indices {
                if games[i].isLive {
                    games[i].homeScore += Int.random(in: 0...1)
                    games[i].awayScore += Int.random(in: 0...1)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
