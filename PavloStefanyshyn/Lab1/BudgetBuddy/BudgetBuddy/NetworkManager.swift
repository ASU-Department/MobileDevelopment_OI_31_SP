//
//  NetworkManager.swift
//  BudgetBuddy
//
//  Created by Nill on 07.12.2025.
//

import Foundation

struct RemotePost: Codable {
    let id: Int
    let title: String
    let body: String
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError(String)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .serverError(let msg): return "Server error: \(msg)"
        case .decodingError(let e): return "Decoding error: \(e.localizedDescription)"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchSampleRemotePosts() async throws -> [RemotePost] {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NetworkError.serverError("Status code \(http.statusCode)")
        }
        do {
            let decoded = try JSONDecoder().decode([RemotePost].self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}


