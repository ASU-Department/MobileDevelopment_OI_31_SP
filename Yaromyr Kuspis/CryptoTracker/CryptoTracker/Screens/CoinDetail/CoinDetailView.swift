//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 19.11.2025.
//

import SwiftUI
import SwiftData

struct CoinDetailView: View {
    let coin: Coin
    
    @State private var showingCoinGecko = false
    
    // Mock data for the price chart. To be replaced with real API data in a future update.
    private let chartData: [Double] = [100, 120, 110, 130, 150, 140, 160, 155]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Price Chart (Last 7 Days)")
                    .font(.headline)
                
                LineChartView(data: chartData)
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                HStack {
                    Text("Current Price:")
                    Spacer()
                    Text(coin.currentPrice, format: .currency(code: "USD"))
                }
                
                HStack {
                    Text("24h Change:")
                    Spacer()
                    Text(String(format: "%.2f%%", coin.priceChangePercentage24h))
                        .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
                }

                Spacer()
                
                Button("Read more on CoinGecko") {
                    showingCoinGecko = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle(coin.name)
        .sheet(isPresented: $showingCoinGecko) {
            SafariView(url: URL(string: "https://www.coingecko.com/en/coins/\(coin.id)")!)
        }
    }
}

// A preview provider needs a sample model container to work with SwiftData.
#Preview {
    // This creates a temporary, in-memory database just for the preview.
    let container = try! ModelContainer(for: Coin.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    // Create a sample coin to display in the preview.
    let sampleCoin = Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png", currentPrice: 65000.0, priceChangePercentage24h: 1.23, isFavorite: true)
    
    return CoinDetailView(coin: sampleCoin)
        .modelContainer(container)
}
