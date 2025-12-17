import SwiftUI
import SwiftData

@main
struct CineGuideApp: App {
    @State private var dependencies: AppDependencyContainer?
    
    init() {
        do {
            let container = try AppDependencyContainer()
            self._dependencies = State(initialValue: container)
        } catch {
            print("Критична помилка ініціалізації залежностей: \(error)")
            fatalError("Не вдалося ініціалізувати додаток")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if let deps = dependencies {
                ContentView()
                    .environment(\.favoriteRepository, deps.favoriteRepository)
                    .modelContainer(deps.modelContainer)
            } else {
                ProgressView("Завантаження...")
                    .progressViewStyle(.circular)
            }
        }
    }
}
