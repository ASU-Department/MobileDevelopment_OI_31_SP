//
//  HomeViewModel.swift
//  Lab2_TimeCapsule
//
//  Created by User on 9.12.2025.
//

import Foundation
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var events: [HistoricalEvent] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedDate: Date = Date()
    
    private let repository: any TimeCapsuleRepositoryProtocol
    
    init(repository: any TimeCapsuleRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedEvents = try await repository.fetchEvents(date: selectedDate)
            self.events = fetchedEvents
        } catch {
            self.errorMessage = "Failed to load: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func deleteEvent(at offsets: IndexSet) {
        let eventsToDelete = offsets.map { events[$0] }
        events.remove(atOffsets: offsets)
        
        Task {
            for event in eventsToDelete {
                try? await repository.deleteEvent(event)
            }
        }
    }
    
    func toggleFavorite(event: HistoricalEvent) {
        Task {
            try? await repository.toggleFavorite(for: event)
        }
    }
}