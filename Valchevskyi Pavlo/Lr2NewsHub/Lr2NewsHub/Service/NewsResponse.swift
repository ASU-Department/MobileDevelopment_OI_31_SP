//
//  NewsResponse.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 22.11.2025.
//

import Foundation
import CryptoKit

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsAPIArticle]
}

struct NewsAPIArticle: Codable, Identifiable {
    var id: UUID {
        if let url = url {
            return url.uuidFromString
        } else {
            return (title ?? "unknown-url").uuidFromString
        }
    }

    struct Source: Codable {
        let id: String?
        let name: String?
    }

    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let content: String?
    let publishedAt: String?
}

// In JSON field id is null for few records, url has all articles
extension String {
    var uuidFromString: UUID {
        let hash = SHA256.hash(data: Data(self.utf8))
        let uuidBytes = Array(hash.prefix(16))
        let uuid = uuidBytes.withUnsafeBytes {
            UUID(uuid: $0.load(as: uuid_t.self))
        }
        return uuid
    }
}
