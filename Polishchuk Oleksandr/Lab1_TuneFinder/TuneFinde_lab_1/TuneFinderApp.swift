import SwiftUI

@main
struct TuneFinderApp: App {

    @State private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.makeRootView()
        }
    }
}
