//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 19.11.2025.
//

import SwiftUI

struct CoinDetailView: View {
    @StateObject private var viewModel: CoinDetailViewModel
    @State private var showingCoinGecko = false
    
    init(coin: CoinEntity) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Price Chart (Last 7 Days)")
                    .font(.headline)
                
                LineChartView(data: viewModel.chartData)
                    .frame(height: 200)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                HStack {
                    Text("Current Price:")
                    Spacer()
                    Text(viewModel.coin.currentPrice, format: .currency(code: "USD"))
                }
                
                HStack {
                    Text("24h Change:")
                    Spacer()
                    Text(String(format: "%.2f%%", viewModel.coin.priceChangePercentage24h))
                        .foregroundColor(viewModel.coin.priceChangePercentage24h >= 0 ? .green : .red)
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
        .navigationTitle(viewModel.coin.name)
        .sheet(isPresented: $showingCoinGecko) {
            SafariView(url: URL(string: "https://www.coingecko.com/en/coins/\(viewModel.coin.id)")!)
        }
    }
}

#Preview {
    let sampleCoin = CoinEntity(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png", currentPrice: 65000.0, priceChangePercentage24h: 1.23, isFavorite: true)
    
    return CoinDetailView(coin: sampleCoin)
}
