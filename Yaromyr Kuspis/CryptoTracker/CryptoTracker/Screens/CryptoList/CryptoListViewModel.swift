//
//  CryptoListViewModel.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 12/12/2025.
//

import SwiftUI
import Combine

@MainActor
class CryptoListViewModel: ObservableObject {
    @Published var coins: [CoinEntity] = []
    @Published var isLoading = false
    @Published var errorAlert: ErrorAlert?
    @Published var showPortfolioOnly = false
    @Published var showThrottledMessage = false
    
    private let repository: CoinRepositoryProtocol
    
    private var lastManualRefreshTime: Date? = nil
    private let refreshCooldown: TimeInterval = 15
    
    init(repository: CoinRepositoryProtocol) {
        self.repository = repository
    }
    
    var filteredCoins: [CoinEntity] {
        if showPortfolioOnly {
            return coins.filter { $0.isFavorite }
        } else {
            return coins
        }
    }
    
    func loadData(force: Bool = false) async {
        await fetchCoinsFromRepo()

        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await repository.fetchData(force: force)
            await fetchCoinsFromRepo()
        } catch {
            self.errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }
    
    func refreshData() async {
        if let lastRefresh = lastManualRefreshTime, Date().timeIntervalSince(lastRefresh) < refreshCooldown {
            withAnimation { showThrottledMessage = true }
            try? await Task.sleep(for: .seconds(2.5))
            withAnimation { showThrottledMessage = false }
            return
        }
        
        lastManualRefreshTime = Date()
        await loadData(force: true)
    }
    
    func toggleFavorite(for coin: CoinEntity) async {
        // Optimistic update
        withAnimation {
            if let index = coins.firstIndex(where: { $0.id == coin.id }) {
                var updatedCoin = coins[index]
                updatedCoin = CoinEntity(
                    id: updatedCoin.id,
                    symbol: updatedCoin.symbol,
                    name: updatedCoin.name,
                    image: updatedCoin.image,
                    currentPrice: updatedCoin.currentPrice,
                    priceChangePercentage24h: updatedCoin.priceChangePercentage24h,
                    isFavorite: !updatedCoin.isFavorite
                )
                coins[index] = updatedCoin
            }
        }
        
        do {
            try await repository.toggleFavorite(coinID: coin.id)
            // Ideally we confirm with DB, but optimistic is fine.
        } catch {
            await fetchCoinsFromRepo()
            self.errorAlert = ErrorAlert(message: "Failed to update favorite: \(error.localizedDescription)")
        }
    }
    
    private func fetchCoinsFromRepo() async {
        do {
            let fetched = try await repository.getCoins()
            self.coins = fetched
        } catch {
            print("Failed to fetch coins: \(error)")
        }
    }
}
