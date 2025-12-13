import SwiftUI
import Combine

@MainActor
class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var showRefreshErrorAlert: Bool = false
    @Published var refreshErrorMessage: String = ""
    
    @Published var searchText: String = "" {
        didSet { UserDefaults.standard.set(searchText, forKey: "lastSearch") }
    }
    @Published var showFavoritesOnly: Bool = false
    @Published var selectedType: String = "All"
    
    private let repository: PokemonRepositoryProtocol
    
    init(repository: PokemonRepositoryProtocol = PokemonRepository()) {
        self.repository = repository
        self.searchText = UserDefaults.standard.string(forKey: "lastSearch") ?? ""
    }
    
    var filteredPokemon: [Pokemon] {
        var filtered = pokemonList
        if showFavoritesOnly { filtered = filtered.filter { $0.isFavorite } }
        if selectedType != "All" { filtered = filtered.filter { $0.type.contains(selectedType) } }
        if !searchText.isEmpty { filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) } }
        return filtered
    }
    
    func loadData(fromRefresh: Bool = false) async {
        if !pokemonList.isEmpty && !fromRefresh {
            return
        }
        
        if pokemonList.isEmpty { isLoading = true }
        if pokemonList.isEmpty { errorMessage = nil }
        
        do {
            let items = try await repository.getPokemon(isRefresh: fromRefresh)
            self.pokemonList = items
        } catch {
            let errorMsg = "Could not update data. Check your internet connection."
            
            if pokemonList.isEmpty {
                let locals = await repository.getLocalFavorites()
                if !locals.isEmpty {
                    self.pokemonList = locals
                    self.refreshErrorMessage = "Displaying offline data."
                    self.showRefreshErrorAlert = true
                } else {
                    self.errorMessage = error.localizedDescription
                }
            } else {
                self.refreshErrorMessage = errorMsg
                self.showRefreshErrorAlert = true
            }
        }
        
        isLoading = false
    }
    
    func toggleFavorite(for pokemonId: Int) {
        if let index = pokemonList.firstIndex(where: { $0.id == pokemonId }) {
            pokemonList[index].isFavorite.toggle()
            saveData()
        }
    }
    
    func triggerSave() {
        saveData()
    }
    
    private func saveData() {
        Task { await repository.saveFavorites(pokemons: pokemonList) }
    }
}
