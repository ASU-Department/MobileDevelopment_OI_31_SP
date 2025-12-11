import SwiftUI
import SwiftData

@main
struct CineGuideApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: FavoriteMovie.self)
        } catch {
            print("Критична помилка створення БД: \(error)")
            fatalError("Не вдалося створити базу даних")
        }
    }

    var favoriteRepository: FavoriteMovieRepository {
        let actor = FavoriteMovieActor(modelContext: container.mainContext)
        return FavoriteMovieRepository(actor: actor)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.favoriteRepository, favoriteRepository)
                .modelContainer(container)
        }
    }
}
