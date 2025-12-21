import Foundation
@testable import Pokedexter

class MockPokemonRepository: PokemonRepositoryProtocol {
    var shouldReturnError = false
    var mockPokemonList: [Pokemon] = []
    var mockLocalFavorites: [Pokemon] = []
    
    var didCallSaveFavorites = false
    var lastRefreshValue = false
    
    func getPokemon(isRefresh: Bool) async throws -> [Pokemon] {
        lastRefreshValue = isRefresh
        
        if shouldReturnError {
            throw URLError(.notConnectedToInternet)
        }
        return mockPokemonList
    }
    
    func getLocalFavorites() async -> [Pokemon] {
        return mockLocalFavorites
    }
    
    func saveFavorites(pokemons: [Pokemon]) async {
        didCallSaveFavorites = true
        mockLocalFavorites = pokemons.filter { $0.isFavorite }
    }
}
