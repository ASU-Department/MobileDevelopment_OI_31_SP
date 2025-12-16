import SwiftUI
import CoreData

struct ContentView: View {
    @State private var pokemonList: [Pokemon] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var searchText = ""
    @State private var showFavoritesOnly = false
    @State private var selectedType = "All"
    
    @State private var showRefreshErrorAlert = false
    @State private var refreshErrorMessage = ""
    
    let context = PersistenceController.shared.container.viewContext
    
    @AppStorage("lastSearch") private var lastSearch: String = ""

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
                
                if isLoading && pokemonList.isEmpty {
                    ProgressView("Catching Pokémon...")
                        .scaleEffect(1.5)
                        .padding()
                        .frame(maxHeight: .infinity)
                    
                } else if let error = errorMessage, pokemonList.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Connection Failed")
                            .font(.headline)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        Button("Retry") {
                            Task { await loadData(fromRefresh: true) }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxHeight: .infinity)
                    
                } else {
                    PokemonListView(pokemonList: $pokemonList,
                                    filteredPokemon: filteredPokemon)
                        .refreshable {
                            await loadData(fromRefresh: true)
                        }
                        .onChange(of: pokemonList) { _ in
                            saveFavorites()
                        }
                }
            }
            .navigationTitle("PokéDexter")
            .padding(.bottom)
            .task {
                searchText = lastSearch
                await loadData()
            }
            .onChange(of: searchText) { newValue in
                lastSearch = newValue
            }
            .alert("Update Failed", isPresented: $showRefreshErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(refreshErrorMessage)
            }
        }
    }
    
    func loadData(fromRefresh: Bool = false) async {
        if !pokemonList.isEmpty && !fromRefresh {
            return
        }
        
        if pokemonList.isEmpty {
            isLoading = true
        }
        
        if pokemonList.isEmpty {
            errorMessage = nil
        }
        
        let savedEntities = fetchLocalPokemon()
        let loadedPokemon = savedEntities.map { Pokemon(entity: $0) }
        
        do {
            let offset = pokemonList.isEmpty ? 0 : Int.random(in: 0...0)
            let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=30&offset=\(offset)")!
            
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let listResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            
            var fetchedPokemon: [Pokemon] = []
            
            try await withThrowingTaskGroup(of: Pokemon?.self) { group in
                for item in listResponse.results {
                    group.addTask {
                        guard let detailUrl = URL(string: item.url) else { return nil }
                        let (detailData, _) = try await URLSession.shared.data(from: detailUrl)
                        let detail = try JSONDecoder().decode(PokemonDetailResponse.self, from: detailData)
                        return detail.toDomain()
                    }
                }
                
                for try await pokemon in group {
                    if let pokemon = pokemon {
                        fetchedPokemon.append(pokemon)
                    }
                }
            }
            
            let favoriteIds = Set(loadedPokemon.filter { $0.isFavorite }.map { $0.id })
            
            let mergedList = fetchedPokemon.sorted(by: { $0.id < $1.id }).map { p -> Pokemon in
                var mutableP = p
                if favoriteIds.contains(p.id) {
                    mutableP.isFavorite = true
                }
                return mutableP
            }
            
            await MainActor.run {
                withAnimation {
                    self.pokemonList = mergedList
                }
            }
            
        } catch {
            let errorMsg = "Could not update data. Check your internet connection."
            
            if pokemonList.isEmpty {
                if !loadedPokemon.isEmpty {
                    self.pokemonList = loadedPokemon
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
    
    func fetchLocalPokemon() -> [PokemonEntity] {
        let request: NSFetchRequest<PokemonEntity> = NSFetchRequest(entityName: "PokemonEntity")
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching local data: \(error)")
            return []
        }
    }
    
    func saveFavorites() {
        let favorites = pokemonList.filter { $0.isFavorite }
        
        context.perform {
            let request: NSFetchRequest<PokemonEntity> = NSFetchRequest(entityName: "PokemonEntity")
            if let results = try? context.fetch(request) {
                for object in results {
                    context.delete(object)
                }
            }
            
            for poke in favorites {
                let entity = PokemonEntity(context: context)
                entity.id = Int64(poke.id)
                entity.name = poke.name
                entity.isFavorite = true
                entity.types = poke.type.joined(separator: ",")
                entity.abilities = poke.abilities.joined(separator: ",")
                entity.imageUrl = poke.imageURL?.absoluteString
                entity.height = Int64(poke.height)
                entity.weight = Int64(poke.weight)
            }
            
            try? context.save()
        }
    }
}
