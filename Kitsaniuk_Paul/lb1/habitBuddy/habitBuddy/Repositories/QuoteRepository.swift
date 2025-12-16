//
//  QuoteRepository.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

final class QuoteRepository: QuoteRepositoryProtocol {

    private let api: QuoteAPIService
    private let cache: QuoteCacheActor

    init(api: QuoteAPIService, cache: QuoteCacheActor) {
        self.api = api
        self.cache = cache
    }

    func getQuote() async -> Quote {
        do {
            let text = try await api.fetchQuote()
            await cache.save(text)
            return Quote(text: text)
        } catch {
            if let cached = await cache.load() {
                return Quote(text: cached + " (offline)")
            } else {
                return Quote(text: "No quote available.")
            }
        }
    }
}
