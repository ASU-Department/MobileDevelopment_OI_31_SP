//
//  NewsDataActor.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 11.12.2025.
//

import Foundation
import SwiftData

@ModelActor
actor NewsDataActor {
    func updateLibrary(with remoteArticles: [NewsAPIArticle]) throws {
        for item in remoteArticles {
            guard let articleId = item.url else { continue }
            
            let rawDate = item.publishedAt ?? "Not found"
            let formattedDate = String(rawDate.replacingOccurrences(of: "T", with: " ").prefix(16))

            let predicate = #Predicate<ArticleModel> { $0.id == articleId }
            let descriptor = FetchDescriptor(predicate: predicate)
            
            if let existing = try? modelContext.fetch(descriptor).first {
                existing.title = item.title ?? "Untitled"
                existing.text = item.content ?? item.description ?? "Not found"
                existing.category = item.source?.name ?? "Not found"
                existing.imageUrl = item.urlToImage
                existing.author = item.author ?? "Not found"
                existing.published = formattedDate
            } else {
                let art = ArticleModel(
                    id: articleId,
                    title: item.title ?? "Untitled",
                    text: item.content ?? item.description ?? "Not found",
                    category: item.source?.name ?? "Not found",
                    articleUrl: item.url,
                    imageUrl: item.urlToImage,
                    author: item.author ?? "Not found",
                    published: formattedDate
                )
                
                modelContext.insert(art)
            }
        }
        try modelContext.save()
    }
    
    func clearAllData() throws {
        try modelContext.delete(model: ArticleModel.self)
        try modelContext.save()
    }
}
