
import Testing
import Foundation
import SwiftData
@testable import CryptoTracker

@MainActor
struct CoinPersistenceActorTests {
    
    @Test func testActorFetchAndSave() async throws {
        let schema = Schema([Coin.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        
        let actor = CoinPersistenceActor(modelContainer: container)

        let crypto = Crypto(id: "test", symbol: "tst", name: "TestCoin", image: "", currentPrice: 10.0, priceChangePercentage24h: 0.0)
        try await actor.updateCoins(from: [crypto])
        
        let fetched = try await actor.fetchCoins()
        #expect(fetched.count == 1)
        #expect(fetched.first?.id == "test")
    }
    
    @Test func testVideoToggleFavorite() async throws {
        let schema = Schema([Coin.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let actor = CoinPersistenceActor(modelContainer: container)
        
        let crypto = Crypto(id: "fav", symbol: "fav", name: "FavCoin", image: "", currentPrice: 10.0, priceChangePercentage24h: 0.0)
        try await actor.updateCoins(from: [crypto])
        
        try await actor.toggleFavorite(coinID: "fav")
        
        let fetched = try await actor.fetchCoins()
        #expect(fetched.first?.isFavorite == true)
    }
}
