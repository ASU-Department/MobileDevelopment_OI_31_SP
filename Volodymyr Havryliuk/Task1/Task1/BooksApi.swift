//
//  BooksApi.swift
//  Task1
//
//  Created by v on 23.11.2025.
//

import Foundation

struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]?
}

struct GoogleBookItem: Codable, Identifiable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let thumbnail: String?
}

class BookAPIService {
    enum APIError: Error {
        case invalidURL
        case requestFailed
        case decodingFailed
    }
    
    func searchBooks(query: String) async throws -> [GoogleBookItem] {
        guard let encodedQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ),
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)")
        else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.requestFailed
        }
        
        do {
            let result = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
            return result.items ?? []
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingFailed
        }
    }
}
