//
//  UITestStubRepository.swift
//  Lab2_TimeCapsule
//
//  Created by User on 18.12.2025.
//

import Foundation

class UITestStubRepository: TimeCapsuleRepositoryProtocol {
    
    var events: [HistoricalEvent] = [
        HistoricalEvent(
            text: "Test Event for UI",
            year: "2024",
            urlString: "https://google.com",
            isFavorite: false
        ),
         HistoricalEvent(
            text: "Second Event",
            year: "1999",
            urlString: "https://apple.com",
            isFavorite: true
        )
    ]
    
    func fetchEvents(date: Date) async throws -> [HistoricalEvent] {
        return events
    }
    
    func getFavorites() async throws -> [HistoricalEvent] {
        return events.filter { $0.isFavorite }
    }
    
    func toggleFavorite(for event: HistoricalEvent) async throws {
        if let index = events.firstIndex(where: { $0.text == event.text }) {
            events[index].isFavorite.toggle()
        }
    }
    
    func deleteEvent(_ event: HistoricalEvent) async throws {
        events.removeAll { $0.text == event.text }
    }
}