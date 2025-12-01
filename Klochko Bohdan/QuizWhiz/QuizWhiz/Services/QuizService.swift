//
//  QuizService.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation

enum QuizServiceError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class QuizService {
    static let shared = QuizService()
    
    private let baseURL = "https://opentdb.com/api.php"
    private let session = URLSession.shared
    
    private init() {}
    
    func fetchQuestions(
        category: String? = nil,
        difficulty: String? = nil,
        amount: Int = 10
    ) async throws -> [Question] {
        var components = URLComponents(string: baseURL)
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "amount", value: "\(amount)"),
            URLQueryItem(name: "type", value: "multiple")
        ]
        
        if let category = category, !category.isEmpty {
            if let categoryId = categoryToId(category) {
                queryItems.append(URLQueryItem(name: "category", value: "\(categoryId)"))
            }
        }
        
        if let difficulty = difficulty, !difficulty.isEmpty {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty.lowercased()))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw QuizServiceError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            
            guard response.responseCode == 0 else {
                throw QuizServiceError.noData
            }
            
            return response.results.map { Question(from: $0) }
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw QuizServiceError.decodingError
        } catch {
            throw QuizServiceError.networkError(error)
        }
    }
    
    private func categoryToId(_ category: String) -> Int? {
        let mapping: [String: Int] = [
            "Science": 17,
            "History": 23,
            "Sports": 21,
            "Music": 12,
            "Literature": 10
        ]
        return mapping[category]
    }
}

