//
//  HistoryDataActorTests.swift
//  Lab2_TimeCapsule
//
//  Created by User on 17.12.2025.
//

import XCTest
import SwiftData
@testable import Lab2_TimeCapsule

final class HistoryDataActorTests: XCTestCase {
    
    var actor: HistoryDataActor!
    var container: ModelContainer!
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: HistoricalEvent.self, configurations: config)
        actor = HistoryDataActor(modelContainer: container)
    }
    
    override func tearDown() {
        actor = nil
        container = nil
    }
    
    func testSaveAndFetchEvents() async throws {
        let events = [
            HistoricalEvent(text: "Actor Test 1", year: "100", urlString: ""),
            HistoricalEvent(text: "Actor Test 2", year: "200", urlString: "")
        ]

        try await actor.save(events: events)
        let fetched = try await actor.fetchEvents(for: 0, day: 0)
        let allEventsDescriptor = FetchDescriptor<HistoricalEvent>()
        let savedEvents = try await actor.modelExecutor.modelContext.fetch(allEventsDescriptor)
        
        XCTAssertEqual(savedEvents.count, 2)
    }
    
    func testToggleFavoriteInActor() async throws {
        let event = HistoricalEvent(text: "Fav Test", year: "2024", urlString: "", isFavorite: false)
        try await actor.save(events: [event])

        try await actor.toggleFavorite(eventID: event.persistentModelID)

        let fetchedFavorites = try await actor.fetchFavorites()
        XCTAssertEqual(fetchedFavorites.count, 1)
        XCTAssertEqual(fetchedFavorites.first?.text, "Fav Test")
    }
}