import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $viewModel.searchText)
                
                FilterView(
                    showFavoritesOnly: $viewModel.showFavoritesOnly,
                    selectedType: $viewModel.selectedType
                )
                
                if viewModel.isLoading && viewModel.pokemonList.isEmpty {
                    ProgressView("Catching Pokémon...")
                        .scaleEffect(1.5)
                        .padding()
                        .frame(maxHeight: .infinity)
                    
                } else if let error = viewModel.errorMessage, viewModel.pokemonList.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Connection Failed")
                            .font(.headline)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding()
                        
                        Button("Retry") {
                            Task { await viewModel.loadData(fromRefresh: true) }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxHeight: .infinity)
                    
                } else {
                    PokemonListView(
                        pokemonList: $viewModel.pokemonList,
                        filteredPokemon: viewModel.filteredPokemon
                    )
                    .refreshable {
                        await viewModel.loadData(fromRefresh: true)
                    }
                    .onChange(of: viewModel.pokemonList) { _ in
                        viewModel.triggerSave()
                    }
                }
            }
            .navigationTitle("PokéDexter")
            .padding(.bottom)
            .task {
                await viewModel.loadData()
            }
            .alert("Update Status", isPresented: $viewModel.showRefreshErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.refreshErrorMessage)
            }
        }
    }
}
