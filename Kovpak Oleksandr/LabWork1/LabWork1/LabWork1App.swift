import SwiftUI
import SwiftData

@main
struct LabWork1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Створюємо контейнер SwiftData вручну
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: StockItem.self)
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            // Передаємо контейнер прямо в ContentView
            ContentView(modelContext: container)
        }
    }
}
