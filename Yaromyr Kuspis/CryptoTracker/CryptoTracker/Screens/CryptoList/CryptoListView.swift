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
    @State private var isLoading = false
    @State private var errorAlert: ErrorAlert?
    
    @State private var showThrottledMessage = false
    @State private var lastManualRefreshTime: Date? = nil
    
    @State private var lastUpdateTime: Date? = nil

    private let coinService = CoinGeckoService()
    
    private let lastUpdateDateKey = "lastUpdateDate"
    private let cacheInterval: TimeInterval = 5 * 60 // 5 minutes
    private let refreshCooldown: TimeInterval = 15 // 15 seconds

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
            .refreshable {
                await refreshData()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("CryptoTracker").font(.headline)
                        if let lastUpdateTime {
                            Text("Last Updated: \(lastUpdateTime.formatted(date: .omitted, time: .standard))")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
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
                if let storedDate = UserDefaults.standard.object(forKey: lastUpdateDateKey) as? Date {
                    self.lastUpdateTime = storedDate
                }
                await loadData(force: false)
            }
            .navigationDestination(for: Coin.self) { coin in
                CoinDetailView(coin: coin)
            }
            .alert(item: $errorAlert) { alert in
                Alert(title: Text("Network Error"),
                      message: Text(alert.message),
                      dismissButton: .default(Text("OK")))
            }
            .overlay(alignment: .top) {
                if showThrottledMessage {
                    Text("Please wait a moment before refreshing again.")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(.thinMaterial)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 4)
                }
            }
        }
    }
    
    private func toggleFavorite(for coin: Coin) {
        withAnimation {
            coin.isFavorite.toggle()
        }
    }
    
    @MainActor
    private func refreshData() async {
        if let lastRefresh = lastManualRefreshTime, Date().timeIntervalSince(lastRefresh) < refreshCooldown {
            print("Refresh throttled.")
            
            try? await Task.sleep(for: .seconds(0.75))
            
            withAnimation {
                showThrottledMessage = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showThrottledMessage = false
                }
            }
            return
        }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.loadData(force: true)
            }
            group.addTask {
                try? await Task.sleep(for: .seconds(0.75))
            }
        }
        
        lastManualRefreshTime = Date()
    }
    
    @MainActor
    private func loadData(force: Bool) async {
        guard !isLoading else { return }
        
        let lastFetchTime = (UserDefaults.standard.object(forKey: lastUpdateDateKey) as? Date) ?? .distantPast
        let now = Date()
        
        let needsUpdate = force || now.timeIntervalSince(lastFetchTime) > cacheInterval
        guard needsUpdate else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let cryptoModels = try await coinService.fetchCoins()
            updateDatabase(with: cryptoModels)
            
            let updateTime = Date()
            self.lastUpdateTime = updateTime
            UserDefaults.standard.set(updateTime, forKey: lastUpdateDateKey)
            
        } catch {
            self.errorAlert = ErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func updateDatabase(with cryptoModels: [Crypto]) {
        for coinModel in cryptoModels {
            let id = coinModel.id
            let predicate = #Predicate<Coin> { $0.id == id }
            let fetchDescriptor = FetchDescriptor(predicate: predicate)
            
            do {
                if let existingCoin = try modelContext.fetch(fetchDescriptor).first {
                    existingCoin.currentPrice = coinModel.currentPrice
                    existingCoin.priceChangePercentage24h = coinModel.priceChangePercentage24h ?? 0.0
                } else {
                    let newCoin = Coin(from: coinModel)
                    modelContext.insert(newCoin)
                }
            } catch {
                print("Failed to fetch or update coin: \(error)")
            }
        }
    }
}


struct ErrorAlert: Identifiable {
    let id = UUID()
    let message: String
}
