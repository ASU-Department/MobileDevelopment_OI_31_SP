
import Foundation
@testable import CryptoTracker

class MockCoinService: CoinGeckoServiceProtocol {
    
    var shouldReturnError = false
    var mockCoins: [Crypto] = []
    
    func fetchCoins() async throws -> [Crypto] {
        if shouldReturnError {
            throw NetworkError.serverError(statusCode: 500)
        }
        return mockCoins
    }
}
