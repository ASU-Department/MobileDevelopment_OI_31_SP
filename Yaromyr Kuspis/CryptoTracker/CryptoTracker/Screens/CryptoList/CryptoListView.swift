//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import SwiftUI
import SwiftData

struct CryptoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Coin.currentPrice, order: .reverse) private var allCoins: [Coin]
    
    @State private var showPortfolioOnly = false
    
    private let coinService = CoinGeckoService()
    
    private let lastFetchKey = "lastFetchTime"
    private let cacheInterval: TimeInterval = 5 * 60 // 5 minutes

    private var filteredCoins: [Coin] {
        if showPortfolioOnly {
            return allCoins.filter { $0.isFavorite }
        } else {
            return allCoins
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCoins) { coin in
                    NavigationLink(value: coin) {
                        CryptoRowView(coin: coin) {
                            toggleFavorite(for: coin)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("CryptoTracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring()) {
                            showPortfolioOnly.toggle()
                        }
                    }) {
                        Image(systemName: showPortfolioOnly ? "star.fill" : "star")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                }
            }
            .safeAreaInset(edge: .bottom, alignment: .center) {
                Link(destination: URL(string: "https://www.coingecko.com?utm_source=CryptoTracker&utm_medium=referral")!) {
                    HStack(spacing: 4) {
                        Text("Data powered by")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Image("coingecko_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 15)
                    }
                    .padding(8)
                    .background(.thinMaterial)
                    .cornerRadius(10)
                }
                .padding(.bottom, 4)
            }
            .task {
                await updateDataIfNeeded()
            }
            .navigationDestination(for: Coin.self) { coin in
                CoinDetailView(coin: coin)
            }
        }
    }
    
    private func toggleFavorite(for coin: Coin) {
        withAnimation {
            coin.isFavorite.toggle()
        }
    }
    
    @MainActor
    private func updateDataIfNeeded() async {
        let lastFetchTime = UserDefaults.standard.double(forKey: lastFetchKey)
        let now = Date().timeIntervalSince1970
        
        if (now - lastFetchTime > cacheInterval) {
            do {
                let cryptoModels = try await coinService.fetchCoins()
                updateDatabase(with: cryptoModels)
                UserDefaults.standard.set(now, forKey: lastFetchKey)
            } catch {
                print("Failed to perform timed update: \(error)")
            }
        }
    }
    
    private func updateDatabase(with cryptoModels: [Crypto]) {
        for coinModel in cryptoModels {
            let id = coinModel.id
            let predicate = #Predicate<Coin> { $0.id == id }
            let fetchDescriptor = FetchDescriptor(predicate: predicate)
            
            do {
                if let existingCoin = try modelContext.fetch(fetchDescriptor).first {
                    // Update existing coin
                    existingCoin.currentPrice = coinModel.currentPrice
                    existingCoin.priceChangePercentage24h = coinModel.priceChangePercentage24h ?? 0.0
                } else {
                    // Insert new coin if it somehow doesn't exist (should be rare)
                    let newCoin = Coin(from: coinModel)
                    modelContext.insert(newCoin)
                }
            } catch {
                print("Failed to fetch or update coin: \(error)")
            }
        }
    }
}
