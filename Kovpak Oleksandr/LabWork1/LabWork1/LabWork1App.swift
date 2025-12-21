import SwiftUI

@main
struct LabWork1App: App {
    // Підключаємо AppDelegate (Advanced task)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
