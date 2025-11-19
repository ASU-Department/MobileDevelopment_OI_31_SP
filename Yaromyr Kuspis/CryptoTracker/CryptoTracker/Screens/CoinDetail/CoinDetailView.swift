//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 19.11.2025.
//

import SwiftUI

struct CoinDetailView: View {
    @ObservedObject var coin: CoinEntity
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
        .navigationTitle(coin.name ?? "Details")
        .sheet(isPresented: $showingCoinGecko) {
            SafariView(url: URL(string: "https://www.coingecko.com/en/coins/\(coin.id ?? "bitcoin")")!)
        }
    }
}
