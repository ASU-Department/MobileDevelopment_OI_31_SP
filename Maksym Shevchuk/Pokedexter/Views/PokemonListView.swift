
import SwiftUI

struct PokemonListView: View {
    @Binding var pokemonList: [Pokemon]
    let filteredPokemon: [Pokemon]
    
    var body: some View {
        List {
            ForEach(filteredPokemon) { pokemon in
                NavigationLink(destination: PokemonDetailView(pokemon: binding(for: pokemon))) {
                    PokemonRow(pokemon: pokemon)
                }
            }
        }
    }
    
    private func binding(for pokemon: Pokemon) -> Binding<Pokemon> {
        guard let index = pokemonList.firstIndex(where: { $0.id == pokemon.id }) else {
            fatalError("Pokemon not found")
        }
        return $pokemonList[index]
    }
}
