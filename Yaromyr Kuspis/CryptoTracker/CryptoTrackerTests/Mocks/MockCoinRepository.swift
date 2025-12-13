
import Foundation
@testable import CryptoTracker

class MockCoinRepository: CoinRepositoryProtocol {
    
    var coins: [CoinEntity] = []
    var shouldFail = false
    
    func getCoins() async throws -> [CoinEntity] {
        if shouldFail {
            throw NetworkError.unknown
        }
        return coins
    }
    
    func fetchData(force: Bool) async throws {
        if shouldFail {
            throw NetworkError.unknown
        }
    }
    
    func toggleFavorite(coinID: String) async throws {
        if shouldFail {
            throw NetworkError.unknown
        }
        if let index = coins.firstIndex(where: { $0.id == coinID }) {
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
        }
    }
}
