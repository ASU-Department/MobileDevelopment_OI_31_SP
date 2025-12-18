//
//  StockDetailTests.swift
//  LabWork1Tests
import Testing // Новий фреймворк Apple
import Foundation
@testable import LabWork1

@MainActor
struct StockDetailTests {

    @Test("Check detail loading success")
    func testLoadDetails() async {
        let mockRepo = MockStockRepository()
        let viewModel = StockDetailViewModel(symbol: "TSLA", repository: mockRepo)
        
        // Дія
        viewModel.loadDetails()
        
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
        
        // Перевірка (#expect замість XCTAssert)
        #expect(viewModel.currentPrice == 150.0)
        #expect(viewModel.priceHistory.count == 5)
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Check error handling")
    func testLoadError() async {
        let mockRepo = MockStockRepository()
        mockRepo.shouldFail = true // Вмикаємо помилку
        
        let viewModel = StockDetailViewModel(symbol: "FAIL", repository: mockRepo)
        
        viewModel.loadDetails()
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        #expect(viewModel.errorMessage != nil)
    }
}
