import SwiftUI
import SwiftData

@main
struct space3App: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: CachedAPOD.self)
    }
}
