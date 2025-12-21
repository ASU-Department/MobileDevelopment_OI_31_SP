import SwiftUI

@MainActor
final class AppCoordinator {

    let repository: SongsRepositoryProtocol

    @MainActor
    init(repository: SongsRepositoryProtocol? = nil) {
        self.repository = repository ?? TuneFinderRepository.shared
    }

    @ViewBuilder
    func makeRootView() -> some View {
        NavigationStack {
            SearchView(viewModel: SearchViewModel(repository: repository))
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        // 1) Перехід до Favorites (MVVM)
                        NavigationLink {
                            FavoritesView(viewModel: FavoritesViewModel(repository: repository))
                        } label: {
                            Image(systemName: "heart")
                        }

                        // 2) Перехід до ізольованої TCA-фічі
                        NavigationLink {
                            let store = SimpleStore(
                                initialState: TCASettingsState(),
                                reducer: TCASettingsReducer()
                            )
                            TCASettingsView(store: store)
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .navigationTitle("TuneFinder")
        }
    }
}


