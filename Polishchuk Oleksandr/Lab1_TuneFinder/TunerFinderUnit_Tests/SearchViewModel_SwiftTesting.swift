import Testing
@testable import TuneFinder

@MainActor
struct SearchViewModel_SwiftTesting {

    @Test
    func emptyQueryClearsSongs() async {
        let repo = MockSongsRepository()
        let history = SearchHistoryActor()
        let vm = SearchViewModel(repository: repo, historyActor: history, autoLoadOnInit: false)

        vm.query = "   "
        await vm.performSearchAsync()

        #expect(vm.songs.isEmpty)
        #expect(vm.errorMessage == nil)
    }

    @Test
    func searchSuccessUpdatesSongsAndHistory() async {
        let repo = MockSongsRepository()
        let history = SearchHistoryActor()
        let vm = SearchViewModel(repository: repo, historyActor: history, autoLoadOnInit: false)

        vm.query = "Mock"
        await vm.performSearchAsync()

        #expect(!vm.songs.isEmpty)
        #expect(vm.recentQueries.first == "Mock")
    }

    @Test
    func filteringFavoritesWorks() async {
        let repo = MockSongsRepository()
        let history = SearchHistoryActor()
        let vm = SearchViewModel(repository: repo, historyActor: history, autoLoadOnInit: false)

        vm.query = "Mock"
        await vm.performSearchAsync()

        // Імітуємо, що фаворит — id першої пісні
        if let first = vm.songs.first {
            // додамо через репо
            try? await repo.addToFavorites(first)
            await vm.reloadFavorites()

            let onlyFav = vm.filteredSongs(showOnlyFavorites: true)
            #expect(onlyFav.allSatisfy { vm.favoriteIds.contains($0.id) })
            #expect(onlyFav.contains(where: { $0.id == first.id }))
        } else {
            Issue.record("No songs returned from mock search")
        }
    }

    @Test
    func toggleFavoriteAddsAndRemoves() async {
        let repo = MockSongsRepository()
        let history = SearchHistoryActor()
        let vm = SearchViewModel(repository: repo, historyActor: history, autoLoadOnInit: false)

        vm.query = "Mock"
        await vm.performSearchAsync()

        guard let song = vm.songs.first else {
            Issue.record("No songs for favorite toggle")
            return
        }

        // add
        await vm.toggleFavoriteAsync(song)
        #expect(vm.favoriteIds.contains(song.id))

        // remove
        await vm.toggleFavoriteAsync(song)
        #expect(!vm.favoriteIds.contains(song.id))
    }
}

