//
//  CryptoRowView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import SwiftUI
import NukeUI

struct CryptoRowView: View {
    let coin: CoinEntity
    
    var onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onFavoriteToggle) {
                ZStack {
                    Image(systemName: "star")
                        .foregroundColor(.gray)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .opacity(coin.isFavorite ? 1.0 : 0.0)
                        .scaleEffect(coin.isFavorite ? 1.0 : 0.5)
                }
                .font(.title3)
            }
            .buttonStyle(.plain)

            LazyImage(url: URL(string: coin.image)) { state in
                if let image = state.image {
                    image.resizable()
                } else {
                    Circle().foregroundColor(.gray.opacity(0.3))
                }
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .font(.headline)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(coin.currentPrice, format: .currency(code: "USD"))
                    .font(.headline)
                    .contentTransition(.numericText(value: coin.currentPrice))
                    .animation(.easeInOut, value: coin.currentPrice)
                
                Text(String(format: "%.2f%%", coin.priceChangePercentage24h))
                    .font(.caption)
                    .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
                    .contentTransition(.numericText(value: coin.priceChangePercentage24h))
                    .animation(.easeInOut, value: coin.priceChangePercentage24h)
            }
        }
        .padding(.vertical, 8)
    }
}
