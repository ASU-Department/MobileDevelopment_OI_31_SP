import Foundation
@testable import LabWork1 // Перевір, чи тут назва твого проекту

class MockStockRepository: StockRepositoryProtocol {
    
    var mockData: [StockItem] = []
    var shouldFail = false
    
    // Імітація запиту в мережу
    func fetchStockData(symbol: String) async throws -> (price: Double, history: [Double]) {
        if shouldFail {
            throw URLError(.notConnectedToInternet)
        }
        // Повертаємо стабільні дані для тестів
        return (150.0, [140, 142, 145, 148, 150])
    }
    
    // Імітація локальної бази
    func fetchLocalStocks() -> [StockItem] {
        return mockData
    }
    
    // Імітація видалення
    func deleteStock(_ item: StockItem) {
        mockData.removeAll { $0.id == item.id }
    }
    
    // Допоміжна функція для тестів (наповнити базу)
    func addStockStub(symbol: String) {
        let item = StockItem(symbol: symbol, price: 100.0)
        mockData.append(item)
    }
}
