import SwiftUI
import SwiftData

@main
struct WeatherWiseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: HistoricalEvent.self)
    }
}
