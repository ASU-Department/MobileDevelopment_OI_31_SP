//
//  QuoteAPIService.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

struct QuoteResponse: Decodable {
    let content: String
    let author: String?
}

final class QuoteAPIService {

    func fetchQuote() async throws -> String {
        let url = URL(string: "https://api.quotable.io/random")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(QuoteResponse.self, from: data)
        if let author = decoded.author {
            return "“\(decoded.content)” — \(author)"
        } else {
            return "“\(decoded.content)”"
        }
    }
}
