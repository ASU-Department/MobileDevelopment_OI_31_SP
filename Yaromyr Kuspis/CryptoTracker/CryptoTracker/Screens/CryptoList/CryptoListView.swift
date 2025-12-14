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

    @State private var showPortfolioOnly = false
    @State private var isLoading = false
    
    private let coinService = CoinGeckoService()
    
    private let lastFetchKey = "lastFetchTime"
    private let cacheInterval: TimeInterval = 5 * 60 // 5 minutes

    private var filteredCoins: [CoinEntity] {
        if showPortfolioOnly {
            return allCoins.filter { $0.isFavorite }
        } else {
            return Array(allCoins)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if isLoading && allCoins.isEmpty {
                    ProgressView("Loading Coins...")
                } else {
                    List {
                        ForEach(filteredCoins, id: \.self) { coin in
                            NavigationLink(value: coin) {
                                CryptoRowView(coin: coin) {
                                    toggleFavorite(for: coin)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
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
                await loadDataIfNeeded()
            }
            .navigationDestination(for: CoinEntity.self) { coin in
                CoinDetailView(coin: coin)
            }
        }
    }
    
    private func toggleFavorite(for coin: CoinEntity) {
        withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
            coin.isFavorite.toggle()
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save favorite status: \(error)")
        }
    }
    
    private func loadDataIfNeeded() async {
        guard !isLoading else { return }
        
        let lastFetchTime = UserDefaults.standard.double(forKey: lastFetchKey)
        let now = Date().timeIntervalSince1970
        
        let needsUpdate = (now - lastFetchTime > cacheInterval) || allCoins.isEmpty
        
        if needsUpdate {
            self.isLoading = true
            
            do {
                let cryptoModels = try await coinService.fetchCoins()
                PersistenceController.shared.saveCoins(from: cryptoModels)
                UserDefaults.standard.set(now, forKey: lastFetchKey)
            } catch {
                print("Failed to load coins: \(error.localizedDescription)")
            }
            
            self.isLoading = false
        }
    }
}
