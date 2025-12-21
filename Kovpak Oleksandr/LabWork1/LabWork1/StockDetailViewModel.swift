import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class StockDetailViewModel: ObservableObject {
    @Published var priceHistory: [Double] = []
    @Published var currentPrice: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let symbol: String
    private let repository: StockRepositoryProtocol // Протокол
    
    // Приймає репозиторій
    init(symbol: String, repository: StockRepositoryProtocol) {
        self.symbol = symbol
        self.repository = repository
    }
    
    func loadDetails() {
        isLoading = true
        Task {
            do {
                let data = try await repository.fetchStockData(symbol: symbol)
                self.currentPrice = data.price
                self.priceHistory = data.history
            } catch {
                self.errorMessage = "Failed to load chart data"
            }
            self.isLoading = false
        }
    }
}
