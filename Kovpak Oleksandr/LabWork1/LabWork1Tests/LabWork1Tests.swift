import XCTest
@testable import LabWork1

@MainActor
final class StockListMainTests: XCTestCase {

    var viewModel: StockListViewModel!
    var mockRepo: MockStockRepository!

    override func setUpWithError() throws {
        // Створюємо свіжий мок перед кожним тестом
        mockRepo = MockStockRepository()
        viewModel = StockListViewModel(repository: mockRepo)
    }

    override func tearDownWithError() throws {
     
        mockRepo = nil
    }

    // Тест 1: Перевірка додавання тікера
    func testAddTicker() {
        let initialCount = viewModel.tickers.count
        viewModel.addTicker("NVDA")
        
        XCTAssertEqual(viewModel.tickers.count, initialCount + 1)
        XCTAssertTrue(viewModel.tickers.contains("NVDA"))
    }
    
    // Тест 2: Завантаження даних (успішне)
    func testLoadDataSuccess() async {
        mockRepo.addStockStub(symbol: "AAPL")
        
        viewModel.loadData()
        
        // Чекаємо трохи, бо це асинхронно
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        
        XCTAssertFalse(viewModel.stocks.isEmpty)
        XCTAssertEqual(viewModel.stocks.first?.symbol, "AAPL")
    }
}
