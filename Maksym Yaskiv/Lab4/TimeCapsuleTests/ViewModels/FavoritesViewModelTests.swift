//
//  FavoritesViewModelTests.swift
//  Lab2_TimeCapsule
//
//  Created by User on 17.12.2025.
//

import Testing
import Foundation
@testable import Lab2_TimeCapsule

@MainActor
struct FavoritesViewModelTests {
    
    @Test("Loading favorites correctly filters only favorite events")
    func loadFavoritesSuccess() async {
        let mockRepo = MockTimeCapsuleRepository()
        let viewModel = FavoritesViewModel(repository: mockRepo)
        
        let favEvent = HistoricalEvent(text: "Fav", year: "2020", urlString: "", isFavorite: true)
        let nonFavEvent = HistoricalEvent(text: "Not Fav", year: "2021", urlString: "", isFavorite: false)
        
        mockRepo.mockEvents = [favEvent, nonFavEvent]
        
        await viewModel.loadFavorites()
        
        #expect(viewModel.favoriteEvents.count == 1)
        #expect(viewModel.favoriteEvents.first?.year == "2020")
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Deleting favorite removes it from list")
    func deleteFavorite() async {
        let mockRepo = MockTimeCapsuleRepository()
        let viewModel = FavoritesViewModel(repository: mockRepo)
        
        let event = HistoricalEvent(text: "To Delete", year: "1999", urlString: "", isFavorite: true)
        mockRepo.mockEvents = [event]
        await viewModel.loadFavorites()
        
        viewModel.deleteFavorites(at: IndexSet(integer: 0))
        
        #expect(viewModel.favoriteEvents.isEmpty)
    }
    
    @Test("Loading favorites displays error message on failure")
        func loadFavoritesFailure() async {
            let mockRepo = MockTimeCapsuleRepository()
            let viewModel = FavoritesViewModel(repository: mockRepo)
            
            mockRepo.shouldFail = true
            
            await viewModel.loadFavorites()
            
            #expect(viewModel.favoriteEvents.isEmpty)
            #expect(viewModel.errorMessage != nil)
        }
}