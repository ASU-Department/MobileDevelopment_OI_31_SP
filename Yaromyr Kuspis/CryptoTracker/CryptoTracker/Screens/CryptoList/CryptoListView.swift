//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import SwiftUI
import CoreData

struct CryptoListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CoinEntity.currentPrice, ascending: false)],
        animation: .default)
    private var allCoins: FetchedResults<CoinEntity>

    @State private var portfolioCoins: [String: Bool] = [
        "bitcoin": true, "ethereum": true, "ripple": true, "solana": true
    ]
    @State private var showPortfolioOnly = false
    @State private var isLoading = false
    
    private let coinService = CoinGeckoService()
    
    private let lastFetchKey = "lastFetchTime"
    private let cacheInterval: TimeInterval = 5 * 60 // 5 minutes

    private var filteredCoins: [CoinEntity] {
        if showPortfolioOnly {
            return allCoins.filter { portfolioCoins[$0.id ?? "", default: false] }
        } else {
            return Array(allCoins)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle(isOn: $showPortfolioOnly) {
                    Text("Show Portfolio Only")
                        .font(.headline)
                }
                .padding(.horizontal)
                .padding(.top)

                if isLoading && allCoins.isEmpty {
                    ProgressView("Loading Coins...")
                } else {
                    List(filteredCoins, id: \.self) { coin in
                        CryptoRowView(coin: coin)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("CryptoTracker")
            .task {
                await loadDataIfNeeded()
            }
        }
    }
    
    private func loadDataIfNeeded() async {
        guard !isLoading else { return }
        
        let lastFetchTime = UserDefaults.standard.double(forKey: lastFetchKey)
        let now = Date().timeIntervalSince1970
        
        // Check if the data needs to be refreshed from the API.
        let needsUpdate = (now - lastFetchTime > cacheInterval) || allCoins.isEmpty
        
        if needsUpdate {
            // Set the loading flag to prevent concurrent fetches.
            self.isLoading = true
            
            do {
                let cryptoModels = try await coinService.fetchCoins()
                PersistenceController.shared.saveCoins(from: cryptoModels)
                UserDefaults.standard.set(now, forKey: lastFetchKey)
            } catch {
                print("Failed to load coins: \(error.localizedDescription)")
            }
            
            // Reset the loading flag after the operation completes.
            self.isLoading = false
        }
    }
}
