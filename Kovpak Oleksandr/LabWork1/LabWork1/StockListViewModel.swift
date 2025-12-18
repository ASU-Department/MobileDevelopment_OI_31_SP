import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class StockListViewModel: ObservableObject {
    @Published var stocks: [StockItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Тепер тут тип Протокол, а не конкретний клас
    private let repository: StockRepositoryProtocol
    var tickers = ["AAPL", "TSLA", "GOOGL", "MSFT", "AMZN"]
    
    // Ініціалізатор змінився: приймає готовий репозиторій
    init(repository: StockRepositoryProtocol) {
        self.repository = repository
        loadLocalData()
    }
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                for ticker in tickers {
                    let _ = try await repository.fetchStockData(symbol: ticker)
                }
                loadLocalData()
            } catch {
                errorMessage = "Network error. Showing offline data."
            }
            isLoading = false
        }
    }
    
    private func loadLocalData() {
        self.stocks = repository.fetchLocalStocks()
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = stocks[index]
            repository.deleteStock(item)
        }
        loadLocalData()
    }
    
    func addTicker(_ symbol: String) {
        let cleanSymbol = symbol.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanSymbol.isEmpty && !tickers.contains(cleanSymbol) {
            tickers.append(cleanSymbol)
            loadData()
        }
    }
}
