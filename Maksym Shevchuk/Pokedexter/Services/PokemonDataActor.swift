import Foundation
import CoreData

actor PokemonDataActor {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    func saveFavorites(_ pokemons: [Pokemon]) {
        let context = container.newBackgroundContext()
        context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PokemonEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                
                for poke in pokemons {
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
                try context.save()
            } catch {
                print("Actor save error: \(error)")
            }
        }
    }
    
    func fetchFavorites() -> [Pokemon] {
        let context = container.newBackgroundContext()
        var result: [Pokemon] = []
        
        context.performAndWait {
            let request: NSFetchRequest<PokemonEntity> = NSFetchRequest(entityName: "PokemonEntity")
            do {
                let entities = try context.fetch(request)
                result = entities.map { Pokemon(entity: $0) }
            } catch {
                print("Actor fetch error: \(error)")
            }
        }
        return result
    }
}
