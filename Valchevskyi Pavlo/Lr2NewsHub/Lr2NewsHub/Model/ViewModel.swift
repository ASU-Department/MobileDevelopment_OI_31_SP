//
//  ViewModel.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 22.11.2025.
//

import Foundation
import SwiftData

@MainActor
class NewsViewModel: ObservableObject {
    @Published var articles: [ArticleModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadLocalData()
    }

    func loadLocalData() {
        let descriptor = FetchDescriptor<ArticleModel>()
        if let saved = try? context.fetch(descriptor) {
            self.articles = saved
        }
    }

    func fetchRemoteNews() async {
        isLoading = true
        errorMessage = nil
//        clearAllArticles() // Сlear data for new testing (only preview)
        do {
            let remote = try await NewsService.shared.fetchNews()

            for item in remote {
                try insertOrUpdate(item)
            }

            try? context.save()
            loadLocalData()

        } catch {
            errorMessage = "Failed to load news. Showing cashed data."
        }

        isLoading = false
    }
    
    func insertOrUpdate(_ item: NewsAPIArticle) throws {
        guard let articleId = item.url else { return }
        
        // Formatted Date "yyyy-MM-dd HH:mm"
        let rawDate = item.publishedAt ?? "Not found"
        var formattedDate = rawDate.replacingOccurrences(of: "T", with: " ")
        if formattedDate.count >= 16 {
            formattedDate = String(formattedDate.prefix(16))
        }
        
        let fetch = FetchDescriptor<ArticleModel>(predicate: #Predicate { $0.id == articleId })
        
        if let existing = try? context.fetch(fetch), let article = existing.first {
            // Update
            article.title = item.title ?? "Untitled"
            article.text = item.content ?? item.description ?? "Not found"
            article.category = item.source?.name ?? "Not found"
            article.articleUrl = item.url
            article.imageUrl = item.urlToImage
            article.author = item.author ?? "Not found"
            article.published = formattedDate
        } else {
            // Insert
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
            context.insert(art)
        }
    }
    
    // Сlear data for new testing (only preview)
    func clearAllArticles() {
        let descriptor = FetchDescriptor<ArticleModel>()
        
        do {
            let allArticles = try context.fetch(descriptor)
            for article in allArticles {
                context.delete(article)
            }
            try context.save()
            articles = []
        } catch {
            print("Failed to clear articles: \(error)")
        }
    }

}
