import SwiftUI

struct ContentView: View {
    // MARK: - Application State
    @State private var favoriteTeams: Set<Team> = []
    @State private var showLiveOnly: Bool = true
    @State private var query: String = ""
    @State private var showFavoritesManager: Bool = false

    // TODO: change to API calls
    @State private var games: [Game] = SampleData.games
    private let allTeams: [Team] = SampleData.allTeams

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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(favoriteTeams), id: \.self) { team in
                            Label("\(team.short)", systemImage: "star.fill")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.yellow.opacity(0.2))
                                .clipShape(Capsule())
                        }
                        if favoriteTeams.isEmpty {
                            Text("No favorites yet. Tap the star to add.")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }
                
                List {
                    Section(header: Text(sectionTitle)) {
                        ForEach(filteredGames) { game in
                            GameRow(
                                game: game,
                                highlight: favoriteTeams.contains(game.home) ||
                                favoriteTeams.contains(game.away)
                            )
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("SportsHub")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFavoritesManager = true
                    } label: {
                        Image(systemName: "star")
                    }
                    .accessibilityLabel("Manage favorites")
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
    }
}

#Preview {
    ContentView()
}
