import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class StockListViewModel: ObservableObject {
    
    // Стан, за яким стежить View
    @Published var stocks: [StockItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: StockRepository
    
    // Змінили let на var, щоб можна було додавати нові тікери
    private var tickers = ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN"]
    
    // Ініціалізація
    init(modelContainer: ModelContainer) {
        self.repository = StockRepository(container: modelContainer)
        loadLocalData()
    }
    
    // Завантаження даних
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                for ticker in tickers {
                    // Викликаємо функцію репозиторія (вона зберігає дані в базу)
                    let _ = try await repository.fetchStockData(symbol: ticker)
                }
                // Оновлюємо UI з бази
                loadLocalData()
            } catch {
                errorMessage = "Network error. Showing offline data."
            }
            isLoading = false
        }
    }
    
    // Читання з локальної бази
    private func loadLocalData() {
        self.stocks = repository.fetchLocalStocks()
    }
    
    // Видалення (свайп)
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = stocks[index]
            repository.deleteStock(item)
        }
        loadLocalData()
    }
    
    // НОВА ФУНКЦІЯ: Додати акцію
    func addTicker(_ symbol: String) {
        let cleanSymbol = symbol.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        // Перевіряємо, щоб не було порожньо і не дублювалось
        if !cleanSymbol.isEmpty && !tickers.contains(cleanSymbol) {
            tickers.append(cleanSymbol)
            loadData() // Одразу пробуємо завантажити дані для нової акції
        }
    }
}
