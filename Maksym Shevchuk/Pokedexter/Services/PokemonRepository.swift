import Foundation

protocol PokemonRepositoryProtocol {
    func getPokemon(isRefresh: Bool) async throws -> [Pokemon]
    func getLocalFavorites() async -> [Pokemon]
    func saveFavorites(pokemons: [Pokemon]) async
}

class PokemonRepository: PokemonRepositoryProtocol {
    private let dataActor = PokemonDataActor()
    
    func getPokemon(isRefresh: Bool) async throws -> [Pokemon] {
        let localFavorites = await dataActor.fetchFavorites()
        
        let offset = isRefresh ? Int.random(in: 0...0) : 0
        
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
        
        let favoriteIds = Set(localFavorites.map { $0.id })
        
        return fetchedPokemon.sorted { $0.id < $1.id }.map { p in
            var mutableP = p
            if favoriteIds.contains(p.id) {
                mutableP.isFavorite = true
            }
            return mutableP
        }
    }
    
    func getLocalFavorites() async -> [Pokemon] {
        return await dataActor.fetchFavorites()
    }
    
    func saveFavorites(pokemons: [Pokemon]) async {
        let favorites = pokemons.filter { $0.isFavorite }
        await dataActor.saveFavorites(favorites)
    }
}
