//
//  CoinPersistenceActor.swift
//  CryptoTracker
//
//  Refactored by Яромир-Олег Куспісь on 12/12/2025.
//

import Foundation
import SwiftData

protocol CoinPersistenceActorProtocol: Actor {
    func fetchCoins() async throws -> [CoinEntity]
    func saveCoins(_ coins: [Coin]) async throws
    func updateCoins(from networkModels: [Crypto]) async throws
    func toggleFavorite(coinID: String) async throws
    func deleteAll() async throws
}

@ModelActor
actor CoinPersistenceActor: CoinPersistenceActorProtocol {
    
    func fetchCoins() throws -> [CoinEntity] {
        let descriptor = FetchDescriptor<Coin>(sortBy: [SortDescriptor(\.currentPrice, order: .reverse)])
        let coins = try modelContext.fetch(descriptor)
        return coins.map { coin in
            CoinEntity(
                id: coin.id,
                symbol: coin.symbol,
                name: coin.name,
                image: coin.image,
                currentPrice: coin.currentPrice,
                priceChangePercentage24h: coin.priceChangePercentage24h,
                isFavorite: coin.isFavorite
            )
        }
    }
    
    func saveCoins(_ coins: [Coin]) throws {
        for coin in coins {
            let id = coin.id
            let descriptor = FetchDescriptor<Coin>(predicate: #Predicate { $0.id == id })
            
            if let existingCoin = try modelContext.fetch(descriptor).first {
                existingCoin.currentPrice = coin.currentPrice
                existingCoin.priceChangePercentage24h = coin.priceChangePercentage24h
                existingCoin.image = coin.image
                existingCoin.name = coin.name
                existingCoin.symbol = coin.symbol
            } else {
                modelContext.insert(coin)
            }
        }
        try modelContext.save()
    }
    
    func updateCoins(from networkModels: [Crypto]) throws {
        for model in networkModels {
            let id = model.id
            let descriptor = FetchDescriptor<Coin>(predicate: #Predicate { $0.id == id })
            
            if let existingCoin = try modelContext.fetch(descriptor).first {
                existingCoin.currentPrice = model.currentPrice
                existingCoin.priceChangePercentage24h = model.priceChangePercentage24h ?? 0.0
                existingCoin.image = model.image
                existingCoin.name = model.name
                existingCoin.symbol = model.symbol
            } else {
                let newCoin = Coin(from: model)
                modelContext.insert(newCoin)
            }
        }
        try modelContext.save()
    }
    
    func toggleFavorite(coinID: String) throws {
        let descriptor = FetchDescriptor<Coin>(predicate: #Predicate { $0.id == coinID })
        if let coin = try modelContext.fetch(descriptor).first {
            coin.isFavorite.toggle()
            try modelContext.save()
        }
    }
    
    func deleteAll() throws {
        try modelContext.delete(model: Coin.self)
        try modelContext.save()
    }
}
