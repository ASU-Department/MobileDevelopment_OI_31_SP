//
//  StoresTests.swift
//  SportsHubDemoTests
//
//  Created by Maksym on 17.12.2025.
//
import XCTest
@testable import SportsHubDemo

@MainActor
final class StoresTests: XCTestCase {
    func testFavoriteStorePersistsTeams() async throws {
        let suiteName = "favorite-store-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        let store = FavoriteStore(defaults: defaults)
        let favorites: Set<Team> = [SampleData.lakers, SampleData.celtics]

        store.save(favorites)
        let loaded = store.load()

        let expectedShorts = favorites.map(\.short).sorted()
        XCTAssertEqual(loaded.map(\.short).sorted(), expectedShorts)
    }

    func testAppSettingsStorePersistsFilters() async throws {
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
