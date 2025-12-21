//
//  MockTimeCapsuleRepository.swift
//  Lab2_TimeCapsule
//
//  Created by User on 17.12.2025.
//

import Foundation
@testable import Lab4_TimeCapsule

class MockTimeCapsuleRepository: TimeCapsuleRepositoryProtocol {
    
    var shouldFail = false
    var mockEvents: [HistoricalEvent] = []
    
    func fetchEvents(date: Date) async throws -> [HistoricalEvent] {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return mockEvents
    }
    
    func getFavorites() async throws -> [HistoricalEvent] {
        if shouldFail {
            throw URLError(.cannotLoadFromNetwork)
        }
        return mockEvents.filter { $0.isFavorite }
    }
    
    func toggleFavorite(for event: HistoricalEvent) async throws {
        if let index = mockEvents.firstIndex(where: { $0.text == event.text }) {
            mockEvents[index].isFavorite.toggle()
        }
    }
    
    func deleteEvent(_ event: HistoricalEvent) async throws {
        mockEvents.removeAll { $0.text == event.text }
    }
}