import Foundation
@testable import CryptoTracker

actor MockCoinPersistenceActor: CoinPersistenceActorProtocol {
    
    var savedCoins: [CoinEntity] = []
    var shouldFail = false
    
    func fetchCoins() async throws -> [CoinEntity] {
        if shouldFail { throw NetworkError.unknown }
        return savedCoins
    }
    
    func saveCoins(_ coins: [Coin]) async throws {
        if shouldFail { throw NetworkError.unknown }
    }
    
    func updateCoins(from networkModels: [Crypto]) async throws {
        if shouldFail { throw NetworkError.unknown }
        
        let entities = await MainActor.run {
            networkModels.map {
                CoinEntity(id: $0.id, symbol: $0.symbol, name: $0.name, image: $0.image, currentPrice: $0.currentPrice, priceChangePercentage24h: $0.priceChangePercentage24h ?? 0, isFavorite: false)
            }
        }
        self.savedCoins = entities
    }
    
    func toggleFavorite(coinID: String) async throws {
        if shouldFail { throw NetworkError.unknown }
        
        let currentCoins = self.savedCoins
        
        let newCoins = await MainActor.run { () -> [CoinEntity] in
            guard let index = currentCoins.firstIndex(where: { $0.id == coinID }) else {
                return currentCoins
            }
            var coins = currentCoins
            let coin = coins[index]
            let newCoin = CoinEntity(
                id: coin.id,
                symbol: coin.symbol,
                name: coin.name,
                image: coin.image,
                currentPrice: coin.currentPrice,
                priceChangePercentage24h: coin.priceChangePercentage24h,
                isFavorite: !coin.isFavorite
            )
            coins[index] = newCoin
            return coins
        }
        
        self.savedCoins = newCoins
    }
    
    func deleteAll() async throws {
        savedCoins.removeAll()
    }
}
