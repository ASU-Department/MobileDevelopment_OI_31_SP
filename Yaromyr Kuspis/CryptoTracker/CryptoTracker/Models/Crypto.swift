//
//  Crypto.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import Foundation

// Network model for decoding the response from the CoinGecko API.
struct Crypto: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let priceChangePercentage24h: Double? // Optional, as the API might not always provide this value.

    // Maps snake_case JSON keys to camelCase properties.
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}
