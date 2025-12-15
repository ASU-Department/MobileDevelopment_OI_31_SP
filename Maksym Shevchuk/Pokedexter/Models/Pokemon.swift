import Foundation

struct Pokemon: Identifiable, Hashable, Codable {
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
    init(entity: PokemonEntity) {
        self.id = Int(entity.id)
        self.name = entity.name ?? "Unknown"
        self.type = (entity.types ?? "").components(separatedBy: ",").filter { !$0.isEmpty }
        self.imageURL = URL(string: entity.imageUrl ?? "")
        self.isFavorite = entity.isFavorite
        self.abilities = (entity.abilities ?? "").components(separatedBy: ",").filter { !$0.isEmpty }
        self.height = Int(entity.height)
        self.weight = Int(entity.weight)
    }
}

struct PokemonListResponse: Codable {
    let results: [PokemonBasic]
}

struct PokemonBasic: Codable {
    let name: String
    let url: String
}

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeElement]
    let abilities: [AbilityElement]
    let sprites: Sprites
    
    struct TypeElement: Codable {
        let type: NameURL
    }
    
    struct AbilityElement: Codable {
        let ability: NameURL
    }
    
    struct NameURL: Codable {
        let name: String
    }
    
    struct Sprites: Codable {
        let front_default: String?
    }
    
    func toDomain() -> Pokemon {
        return Pokemon(
            id: id,
            name: name.capitalized,
            type: types.map { $0.type.name.capitalized },
            imageURL: URL(string: sprites.front_default ?? ""),
            isFavorite: false,
            abilities: abilities.map { $0.ability.name.capitalized },
            height: height,
            weight: weight
        )
    }
}
