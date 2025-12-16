//
//  Coin.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 20.11.2025.
//

import Foundation
import SwiftData

@Model
final class Coin {
    @Attribute(.unique) var id: String
    
    var symbol: String
    var name: String
    var image: String
    var currentPrice: Double
    var priceChangePercentage24h: Double
    var isFavorite: Bool

    init(id: String, symbol: String, name: String, image: String, currentPrice: Double, priceChangePercentage24h: Double, isFavorite: Bool = false) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.priceChangePercentage24h = priceChangePercentage24h
        self.isFavorite = isFavorite
    }
    
    convenience init(from crypto: Crypto) {
        self.init(
            id: crypto.id,
            symbol: crypto.symbol,
            name: crypto.name,
            image: crypto.image,
            currentPrice: crypto.currentPrice,
            priceChangePercentage24h: crypto.priceChangePercentage24h ?? 0.0
        )
    }
    
}
