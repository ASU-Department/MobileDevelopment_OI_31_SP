import XCTest
@testable import SportsHubDemo

@MainActor
final class StoresTests: XCTestCase {
    func testFavoriteStorePersistsTeams() {
        let suiteName = "favorite-store-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        let store = FavoriteStore(defaults: defaults)
        let favorites: Set<Team> = [SampleData.lakers, SampleData.celtics]

        store.save(favorites)
        let loaded = store.load()

        XCTAssertEqual(loaded, favorites)
    }

    func testAppSettingsStorePersistsFilters() {
        let suiteName = "app-settings-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        let store = AppSettingsStore(defaults: defaults)

        store.showLiveOnly = false
        store.query = "Lakers"
        let date = Date()
        store.lastUpdateDate = date

        XCTAssertFalse(store.showLiveOnly)
        XCTAssertEqual(store.query, "Lakers")
        XCTAssertEqual(store.lastUpdateDate, date)
    }
}
