
import Testing
import Foundation
@testable import CryptoTracker

@MainActor
struct CryptoListViewModelTests {
    
    @Test func testInitialLoad() async throws {
        let mockRepo = MockCoinRepository()
        let vm = CryptoListViewModel(repository: mockRepo)
        
        mockRepo.coins = [
            CoinEntity(id: "1", symbol: "BTC", name: "Bitcoin", image: "", currentPrice: 50000, priceChangePercentage24h: 0, isFavorite: false)
        ]
        
        await vm.loadData(force: true)
        
        let coins = vm.coins
        #expect(coins.count == 1)
        #expect(coins.first?.name == "Bitcoin")
    }
    
    @Test func testFilterFavorites() async throws {
        let mockRepo = MockCoinRepository()
        let vm = CryptoListViewModel(repository: mockRepo)
        
        mockRepo.coins = [
            CoinEntity(id: "1", symbol: "BTC", name: "Bitcoin", image: "", currentPrice: 50000, priceChangePercentage24h: 0, isFavorite: true),
            CoinEntity(id: "2", symbol: "ETH", name: "Ethereum", image: "", currentPrice: 3000, priceChangePercentage24h: 0, isFavorite: false)
        ]
        
        await vm.loadData(force: true)
        vm.showPortfolioOnly = true
        
        let filtered = vm.filteredCoins
        #expect(filtered.count == 1)
        #expect(filtered.first?.symbol == "BTC")
    }
    
    @Test func testErrorHandling() async throws {
        let mockRepo = MockCoinRepository()
        mockRepo.shouldFail = true
        let vm = CryptoListViewModel(repository: mockRepo)
        
        await vm.loadData(force: true)
        
        let error = vm.errorAlert
        #expect(error != nil)
    }
}
