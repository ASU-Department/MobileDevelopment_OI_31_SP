//
//  CoinGeckoService.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case serverError(statusCode: Int)
    case rateLimitExceeded
    case decodingError
    case unknown

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL for the request was invalid."
        case .serverError(let statusCode):
            return "The server responded with an error: \(statusCode)."
        case .rateLimitExceeded:
            return "Updating too quickly. Please try again in a moment"
        case .decodingError:
            return "The data couldn't be read because it isn't in the correct format."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

class CoinGeckoService {
    
    func fetchCoins() async throws -> [Crypto] {
            guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false") else {
                throw NetworkError.badURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            if httpResponse.statusCode == 429 {
                throw NetworkError.rateLimitExceeded
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let coins = try JSONDecoder().decode([Crypto].self, from: data)
                return coins
            } catch {
                throw NetworkError.decodingError
            }
        }
    
    // Example function for a future request that would use the private API key.
    private func somePrivateAPIRequest() {
        let apiKey = Secrets.coinGeckoApiKey
        print("Using private API key retrieved via .xcconfig: \(apiKey)")
        // A URLSession request using the key would be implemented here.
    }
}
