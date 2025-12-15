//
//  EventDetailViewModel.swift
//  Lab2_TimeCapsule
//
//  Created by User on 9.12.2025.
//

import Foundation
import SwiftData

@MainActor
class EventDetailViewModel: ObservableObject {
    @Published var event: HistoricalEvent
    
    private let repository: any TimeCapsuleRepositoryProtocol
    
    init(event: HistoricalEvent, repository: any TimeCapsuleRepositoryProtocol) {
        self.event = event
        self.repository = repository
    }
    
    func toggleFavorite() {
        Task {
            do {
                try await repository.toggleFavorite(for: event)
            } catch {
                print("Error toggling favorite: \(error)")
            }
        }
    }
}