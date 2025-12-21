import SwiftUI
import SwiftData

@main
struct LabWork1App: App {
    // Підключаємо AppDelegate 
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Активуємо SwiftData для моделі StockItem
        .modelContainer(for: StockItem.self)
    }
}
