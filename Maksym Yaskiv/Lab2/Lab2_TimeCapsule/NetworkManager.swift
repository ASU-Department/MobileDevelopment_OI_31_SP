//
//  NetworkManager.swift
//  Lab2_TimeCapsule
//
//  Created by User on 22.11.2025.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchEvents(month: Int, day: Int) async throws -> [WikiEventDTO] {
        let urlString = "https://api.wikimedia.org/feed/v1/wikipedia/en/onthisday/events/\(month)/\(day)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(WikiAPIResponse.self, from: data)
        return decodedResponse.events
    }
}