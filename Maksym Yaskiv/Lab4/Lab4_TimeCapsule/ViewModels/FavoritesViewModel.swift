//
//  FavoritesViewModel.swift
//  Lab2_TimeCapsule
//
//  Created by User on 10.12.2025.
//

import Foundation
import SwiftData

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteEvents: [HistoricalEvent] = []
    @Published var errorMessage: String?
    
    private let repository: any TimeCapsuleRepositoryProtocol
    
    init(repository: any TimeCapsuleRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadFavorites() async {
        do {
            self.favoriteEvents = try await repository.getFavorites()
        } catch {
            self.errorMessage = "Could not load favorites: \(error.localizedDescription)"
        }
    }
    
    func deleteFavorites(at offsets: IndexSet) {
        let eventsToDelete = offsets.map { favoriteEvents[$0] }
        
        favoriteEvents.remove(atOffsets: offsets)
        
        Task {
            for event in eventsToDelete {
                do {
                    try await repository.deleteEvent(event)
                } catch {
                    await loadFavorites() 
                }
            }
        }
    }
}