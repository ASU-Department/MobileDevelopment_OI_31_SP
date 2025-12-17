
import XCTest
@testable import CryptoTracker

@MainActor
final class CoinRepositoryTests: XCTestCase {
    
    var repository: CoinRepository!
    var mockService: MockCoinService!
    var mockActor: MockCoinPersistenceActor!
    
    override func setUp() async throws {
        mockService = MockCoinService()
        mockActor = MockCoinPersistenceActor()
        repository = CoinRepository(service: mockService, actor: mockActor)
    }
    
    override func tearDown() async throws {
        repository = nil
        mockService = nil
        mockActor = nil
    }
    
    func testFetchDataSuccess() async throws {
        // Given
        let expectedCoins = [
            Crypto(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "url", currentPrice: 50000, priceChangePercentage24h: 0.2)
        ]
        mockService.mockCoins = expectedCoins
        
        // When
        try await repository.fetchData(force: true)
        
        // Then
        let savedCoins = await mockActor.savedCoins
        XCTAssertEqual(savedCoins.count, 1)
        XCTAssertEqual(savedCoins.first?.id, "bitcoin")
    }
    
    func testFetchDataFailure() async throws {
        // Given
        mockService.shouldReturnError = true
        
        // When/Then
        do {
            try await repository.fetchData(force: true)
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testGetCoinsFromActor() async throws {
        // Given
        let crypto = Crypto(id: "ethereum", symbol: "eth", name: "Ethereum", image: "url", currentPrice: 3000, priceChangePercentage24h: 1.5)
        try await mockActor.updateCoins(from: [crypto])
        
        // When
        var coins = try await repository.getCoins()
        
        // Then
        try await mockActor.toggleFavorite(coinID: "ethereum")
        coins = try await repository.getCoins()
        
        XCTAssertEqual(coins.count, 1)
        XCTAssertEqual(coins.first?.id, "ethereum")
        XCTAssertTrue(coins.first?.isFavorite ?? false)
    }
}
