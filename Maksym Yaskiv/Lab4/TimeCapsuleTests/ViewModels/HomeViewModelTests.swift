//
//  HomeViewModelTests.swift
//  Lab2_TimeCapsule
//
//  Created by User on 17.12.2025.
//

import XCTest
@testable import Lab2_TimeCapsule

@MainActor
final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockRepo: MockTimeCapsuleRepository!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockTimeCapsuleRepository()
        viewModel = HomeViewModel(repository: mockRepo)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }
    
    func testLoadDataSuccess() async {
        let testEvent = HistoricalEvent(text: "Test Event", year: "2000", urlString: "")
        mockRepo.mockEvents = [testEvent]
        
        await viewModel.loadData()
        
        XCTAssertFalse(viewModel.isLoading, "Loading indicator should be hidden")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil")
        XCTAssertEqual(viewModel.events.count, 1, "Should load exactly one event")
        XCTAssertEqual(viewModel.events.first?.text, "Test Event")
    }
    
    func testLoadDataFailure() async {
        mockRepo.shouldFail = true
        
        await viewModel.loadData()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set on failure")
        XCTAssertTrue(viewModel.events.isEmpty, "Events list should be empty on failure")
    }
    
    func testDeleteEvent() {
        let event1 = HistoricalEvent(text: "Event 1", year: "1990", urlString: "")
        let event2 = HistoricalEvent(text: "Event 2", year: "1991", urlString: "")
        viewModel.events = [event1, event2]
        mockRepo.mockEvents = [event1, event2]
        
        viewModel.deleteEvent(at: IndexSet(integer: 0))
        
        XCTAssertEqual(viewModel.events.count, 1)
        XCTAssertEqual(viewModel.events.first?.text, "Event 2")
    }
    
    func testToggleFavorite() async {
            let event = HistoricalEvent(text: "Fav Event", year: "2024", urlString: "")
            mockRepo.mockEvents = [event]
            
            viewModel.toggleFavorite(event: event)
            
            try? await Task.sleep(nanoseconds: 100_000_000)
            
            XCTAssertTrue(mockRepo.mockEvents.first?.isFavorite ?? false)
        }
}