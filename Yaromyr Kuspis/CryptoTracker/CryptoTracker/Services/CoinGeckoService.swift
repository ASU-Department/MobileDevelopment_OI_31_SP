//
//  CoinGeckoService.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import Foundation

class CoinGeckoService {
    
    func fetchCoins() async throws -> [Crypto] {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false") else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Crypto].self, from: data)
        } catch {
            print("Error fetching or decoding data: \(error)")
            throw error
        }
    }
    
    // Example function for a future request that would use the private API key.
    private func somePrivateAPIRequest() {
        let apiKey = Secrets.coinGeckoApiKey
        print("Using private API key retrieved via .xcconfig: \(apiKey)")
        // A URLSession request using the key would be implemented here.
    }
}
