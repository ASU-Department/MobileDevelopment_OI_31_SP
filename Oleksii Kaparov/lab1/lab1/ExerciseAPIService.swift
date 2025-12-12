//
//  ExerciseAPIService.swift
//  lab1
//
//  Created by A-Z pack group on 11.12.2025.
//

import Foundation

final class ExerciseAPIService {
    private let apiKey = "53d448ddcamsh091e87c2b35cbf0p136a29jsn451249ed86da"
    private let host = "exercisedb-api1.p.rapidapi.com"

    func searchExercises(search: String) async throws -> [ExerciseAPIModel] {
        let q = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "strength%20exercises"
        guard let url = URL(string: "https://exercisedb-api1.p.rapidapi.com/api/v1/exercises/search?search=\(q)") else {
            throw URLError(.badURL)
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        req.setValue(host, forHTTPHeaderField: "X-RapidAPI-Host")

        let (data, response) = try await URLSession.shared.data(for: req)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? "<no body>"
            print("HTTP \(http.statusCode):", body)
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(ExerciseSearchResponse.self, from: data)
        return decoded.data
    }
}
