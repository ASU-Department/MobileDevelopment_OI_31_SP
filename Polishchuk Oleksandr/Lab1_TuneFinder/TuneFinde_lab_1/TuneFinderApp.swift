import SwiftUI

@main
struct TuneFinderApp: App {
    private let coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.makeRootView()
        }
    }
}
