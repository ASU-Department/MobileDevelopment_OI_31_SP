import Foundation
import SwiftUI

struct Pokemon: Identifiable, Hashable {
    let id: Int
    let name: String
    let type: [String]
    let imageURL: URL?
    var isFavorite: Bool = false
    let abilities: [String]
    let height: Int
    let weight: Int
}


extension Pokemon {
    static let samplePokemon = [
        Pokemon(
            id: 25,
            name: "Pikachu",
            type: ["Electric"],
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"),
            abilities: ["Static", "Lightning Rod"],
            height: 4,
            weight: 60
        ),
        Pokemon(
            id: 1,
            name: "Bulbasaur",
            type: ["Grass", "Poison"],
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
            abilities: ["Overgrow", "Chlorophyll"],
            height: 7,
            weight: 69
        ),
        Pokemon(
            id: 4,
            name: "Charmander",
            type: ["Fire"],
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png"),
            abilities: ["Blaze", "Solar Power"],
            height: 6,
            weight: 85
        )
    ]
}
