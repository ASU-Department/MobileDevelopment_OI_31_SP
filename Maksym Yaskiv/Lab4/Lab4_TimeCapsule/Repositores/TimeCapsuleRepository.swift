//
//  TimeCapsuleRepository.swift
//  Lab2_TimeCapsule
//
//  Created by User on 9.12.2025.
//

import Foundation
import SwiftData

class TimeCapsuleRepository {
    private let networkManager = NetworkManager.shared
    private let dataActor: HistoryDataActor
    
    init(actor: HistoryDataActor) {
        self.dataActor = actor
    }
    
    func fetchEvents(date: Date) async throws -> [HistoricalEvent] {
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        do {
            let dtos = try await networkManager.fetchEvents(month: month, day: day)
            
            let events = dtos.map { dto in
                HistoricalEvent(
                    text: dto.text,
                    year: String(dto.year),
                    urlString: dto.pages?.first?.content_urls.desktop.page ?? ""
                )
            }
            
            try await dataActor.save(events: events)
            
            return events
        } catch {
            throw error
        }
    }
    
    func getFavorites() async throws -> [HistoricalEvent] {
        return try await dataActor.fetchFavorites()
    }
    
    func toggleFavorite(for event: HistoricalEvent) async throws {
        try await dataActor.toggleFavorite(eventID: event.persistentModelID)
    }
    
    func deleteEvent(_ event: HistoricalEvent) async throws {
        try await dataActor.deleteEvent(eventID: event.persistentModelID)
    }
}