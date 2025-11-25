import SwiftUI
import Combine

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @StateObject private var player = AudioPlayerManager()
    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    // @State для динаміки UI (вимога лаби)
    @State private var showOnlyFavorites = false
    
    var filteredResults: [Song] {
        if showOnlyFavorites {
            return vm.results.filter { favoritesVM.isFavorite($0) }
        }
        return vm.results
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                // Search bar
                HStack {
                    TextField("Song or artist...", text: $vm.query)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit { Task { await vm.search() } }
                    
                    Button("Search") {
                        Task { await vm.search() }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                // Toggle (інтерактивність)
                Toggle("Show only favorites", isOn: $showOnlyFavorites)
                    .padding(.horizontal, 2)
                
                // Content
                ZStack {
                    if isPreview {
                        EmptyStateView(message: "Preview mode")
                    } else if vm.isLoading {
                        ProgressView("Loading...")
                    } else if let msg = vm.errorMessage {
                        EmptyStateView(message: msg)
                    } else if filteredResults.isEmpty && vm.query.isEmpty {
                        EmptyStateView(message: "Type something and tap Search")
                    } else {
                        ResultsListView(
                            songs: filteredResults,
                            favoritesVM: favoritesVM,
                            player: player
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
            .navigationTitle("TuneFinder")
        }
    }
}
#Preview {
    SearchView()
        .environmentObject(FavoritesViewModel()) // ✅ інакше Canvas білий/креш
}
