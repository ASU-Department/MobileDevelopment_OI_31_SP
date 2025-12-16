//
//  CoinEntity.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 12/12/2025.
//

import Foundation

struct CoinEntity: Identifiable, Hashable, Sendable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let priceChangePercentage24h: Double
    let isFavorite: Bool
}


