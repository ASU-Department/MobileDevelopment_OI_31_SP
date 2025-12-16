//
//  NewsService.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 22.11.2025.
//

import Foundation

class NewsService {
    static let shared = NewsService()
    private init() {}

    private let url = URL(string:
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=ba7276682e8741899c60570635b67349"
    )!

    func fetchNews() async throws -> [NewsAPIArticle] {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 4 // Request
        config.timeoutIntervalForResource = 4 // Server
        let session = URLSession(configuration: config)

        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
        return decoded.articles
    }
}
