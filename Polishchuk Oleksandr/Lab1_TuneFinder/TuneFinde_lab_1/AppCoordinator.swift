import SwiftUI

@MainActor
final class AppCoordinator {

    let repository: SongsRepositoryProtocol

    @MainActor
    init(repository: SongsRepositoryProtocol? = nil) {
        if let repository {
            self.repository = repository
        } else if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            // Для XCUITest: без мережі/SwiftData
            self.repository = MockSongsRepository()
        } else {
            self.repository = TuneFinderRepository.shared
        }
    }

    @ViewBuilder
    func makeRootView() -> some View {
        NavigationStack {
            SearchView(viewModel: SearchViewModel(repository: repository))
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {

                        NavigationLink {
                            FavoritesView(viewModel: FavoritesViewModel(repository: repository))
                        } label: {
                            Image(systemName: "heart")
                        }
                        .accessibilityIdentifier("navFavoritesButton")

                        NavigationLink {
                            let store = SimpleStore(
                                initialState: TCASettingsState(),
                                reducer: TCASettingsReducer()
                            )
                            TCASettingsView(store: store)
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        .accessibilityIdentifier("navSettingsButton")
                    }
                }
                .navigationTitle("TuneFinder")
        }
    }
}
