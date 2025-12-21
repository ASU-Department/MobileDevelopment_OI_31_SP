//
//  StockDetailViewModel.swift
//  LabWork1

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
    private let repository: StockRepository
    
    init(symbol: String, modelContainer: ModelContainer) {
        self.symbol = symbol
        self.repository = StockRepository(container: modelContainer)
    }
    
    func loadDetails() {
        isLoading = true
        Task {
            do {
                // Викликаємо нову функцію репозиторія
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
