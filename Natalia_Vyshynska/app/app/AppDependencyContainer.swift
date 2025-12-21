import Foundation
import SwiftData

final class AppDependencyContainer {
    let modelContainer: ModelContainer
    let favoriteRepository: FavoriteMovieRepository
    
    init() throws {
        modelContainer = try ModelContainer(for: FavoriteMovie.self)
        
        let actor = FavoriteMovieActor(modelContainer: modelContainer)
        
        favoriteRepository = FavoriteMovieRepository(actor: actor)
    }
}
