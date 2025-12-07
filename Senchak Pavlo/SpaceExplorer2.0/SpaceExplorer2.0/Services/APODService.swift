//
//  APODService.swift
//  space3
//
//  Created by Pab1m on 29.11.2025.
//


import Foundation

class APODService {

    // Можеш повернути свій власний ключ
    private let apiKey = "W43aXnOXgYF25FBRlIibfLrUrKbUXCLgUb8jwFNg"

    func fetchAPOD() async throws -> APODResponse {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(APODResponse.self, from: data)
    }
}
