//
//  CoinRepository.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 12/12/2025.
//

import Foundation
import SwiftData

protocol CoinRepositoryProtocol {
    func getCoins() async throws -> [CoinEntity]
    func fetchData(force: Bool) async throws
    func toggleFavorite(coinID: String) async throws
}

class CoinRepository: CoinRepositoryProtocol {
    private let service: CoinGeckoService
    private let actor: CoinPersistenceActor
    
    private var lastUpdateTime: Date? = nil
    private let cacheInterval: TimeInterval = 5 * 60 // 5 minutes
    
    init(service: CoinGeckoService = CoinGeckoService(), actor: CoinPersistenceActor) {
        self.service = service
        self.actor = actor
    }
    
    func getCoins() async throws -> [CoinEntity] {
        return try await actor.fetchCoins()
    }
    
    func fetchData(force: Bool) async throws {
        if !force, let lastUpdate = lastUpdateTime, Date().timeIntervalSince(lastUpdate) < cacheInterval {
            return
        }
        
        // Fetch from API
        let cryptoModels = try await service.fetchCoins()
        
        // Update DB via Actor
        try await actor.updateCoins(from: cryptoModels)
        
        self.lastUpdateTime = Date()
    }
    
    func toggleFavorite(coinID: String) async throws {
        try await actor.toggleFavorite(coinID: coinID)
    }
}
