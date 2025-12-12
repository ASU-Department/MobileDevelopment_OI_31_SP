//
//  BalldontlieAPI.swift
//  SportsHubDemo
//
//  Created by Maksym on 18.11.2025.
//

import Foundation

struct BDLTeam: Decodable {
    let id: Int
    let abbreviation: String
    let city: String
    let conference: String
    let division: String
    let full_name: String
    let name: String
}

struct BDLGame: Decodable {
    let id: Int
    let date: String
    let home_team: BDLTeam
    let home_team_score: Int
    let visitor_team: BDLTeam
    let visitor_team_score: Int
    let period: Int
    let status: String
    let time: String
    let season: Int
    let postseason: Bool
}

private struct BDLListResponse<T: Decodable>: Decodable {
    let data: [T]
}

enum NetworkError: LocalizedError {
    case badURL
    case missingAPIKey
    case badStatus(Int)
    case decoding(Error)
    case transport(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid API URL."
        case .missingAPIKey:
            return "API key is not configured."
        case .badStatus(let code):
            return "Server responded with status code \(code)."
        case .decoding:
            return "Failed to decode server response."
        case .transport(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown network error."
        }
    }
}

final class BalldontlieClient {
    static let shared = BalldontlieClient()
    private let baseUrl = URL(string: "https://api.balldontlie.io/v1")!
    
    private var apiKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "BALDONTLIE_API_KEY") as? String
    }
    
    private init() {}
    
    func fetchGames(season: Int = 2024, perPage: Int = 25) async throws -> [BDLGame] {
        var components = URLComponents(
            url: baseUrl.appendingPathComponent("games"),
            resolvingAgainstBaseURL: false
        )
        
        components?.queryItems = [
            URLQueryItem(name: "seasons[]", value: String(season)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        guard let url = components?.url else {
            throw NetworkError.badURL
        }
        
        guard let key = apiKey, !key.isEmpty else {
            throw NetworkError.missingAPIKey
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(key, forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            guard (200..<300).contains(http.statusCode) else {
                throw NetworkError.badStatus(http.statusCode)
            }
            
            do {
                let decoded = try JSONDecoder().decode(BDLListResponse<BDLGame>.self, from: data)
                return decoded.data
            } catch {
                throw NetworkError.decoding(error)
            }
        } catch {
            throw NetworkError.transport(error)
        }
    }
}
