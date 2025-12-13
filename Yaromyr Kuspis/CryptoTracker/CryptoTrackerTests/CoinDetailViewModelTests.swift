
import XCTest
@testable import CryptoTracker

final class CoinDetailViewModelTests: XCTestCase {
    
    func testInitialization() async {
        let coin = CoinEntity(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: "http://test.com/btc.png",
            currentPrice: 50000.0,
            priceChangePercentage24h: 2.5,
            isFavorite: true
        )
        
        await MainActor.run {
            let viewModel = CoinDetailViewModel(coin: coin)
            
            XCTAssertEqual(viewModel.coin.id, "bitcoin")
            XCTAssertEqual(viewModel.coin.currentPrice, 50000.0)
            XCTAssertTrue(viewModel.coin.isFavorite)
        }
    }
    

}
