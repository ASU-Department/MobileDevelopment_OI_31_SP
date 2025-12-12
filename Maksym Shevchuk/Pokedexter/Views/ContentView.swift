
import SwiftUI

struct ContentView: View {
    @State private var pokemonList = Pokemon.samplePokemon
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var selectedType = "All"
    
    var filteredPokemon: [Pokemon] {
        var filtered = pokemonList
        
        if showFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        if selectedType != "All" {
            filtered = filtered.filter { $0.type.contains(selectedType) }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText)
                
                FilterView(showFavoritesOnly: $showFavoritesOnly,
                          selectedType: $selectedType)
                
                PokemonListView(pokemonList: $pokemonList,
                               filteredPokemon: filteredPokemon)
            }
            .navigationTitle("PokéDexter")
            .padding()
        }
    }
}




