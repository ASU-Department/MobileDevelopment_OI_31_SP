import XCTest
import CoreData
@testable import Pokedexter

class PokemonActorTests: XCTestCase {
    
    var actor: PokemonDataActor!
    var persistenceController: PersistenceController!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        actor = PokemonDataActor(container: persistenceController.container)
    }

    func testActorSavesAndRetrievesAbilities() async throws {
        let abilities = ["Static", "Lightning Rod"]
        let pikachu = Pokemon(
            id: 25,
            name: "Pikachu",
            type: ["Electric"],
            imageURL: nil,
            isFavorite: true,
            abilities: abilities,
            height: 4,
            weight: 60
        )
        
        await actor.saveFavorites([pikachu])
        
        let fetched = await actor.fetchFavorites()
        
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.name, "Pikachu")
        XCTAssertEqual(fetched.first?.abilities, abilities)
    }
}
