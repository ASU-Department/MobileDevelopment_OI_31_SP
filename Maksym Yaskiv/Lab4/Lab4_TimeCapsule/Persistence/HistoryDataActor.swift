//
//  HistoryDataActor.swift
//  Lab2_TimeCapsule
//
//  Created by User on 9.12.2025.
//

import Foundation
import SwiftData

actor HistoryDataActor: ModelActor {
    nonisolated public let modelContainer: ModelContainer
    nonisolated public let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func save(events: [HistoricalEvent]) throws {
        for event in events {
            modelContext.insert(event)
        }
        try modelContext.save()
    }
    
    func fetchEvents(for month: Int, day: Int) throws -> [HistoricalEvent] {
        let descriptor = FetchDescriptor<HistoricalEvent>()
        return try modelContext.fetch(descriptor)
    }
    
    func fetchFavorites() throws -> [HistoricalEvent] {
        let descriptor = FetchDescriptor<HistoricalEvent>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.year)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func toggleFavorite(eventID: PersistentIdentifier) throws {
        if let event = self[eventID, as: HistoricalEvent.self] {
            event.isFavorite.toggle()
            try modelContext.save()
        }
    }
    
    func deleteEvent(eventID: PersistentIdentifier) throws {
        if let event = self[eventID, as: HistoricalEvent.self] {
            modelContext.delete(event)
            try modelContext.save()
        }
    }
}