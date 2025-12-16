//
//  NewsDataActorTests.swift
//  Lr2NewsHubTests
//
//  Created by Pavlo on 14.12.2025.
//

import XCTest
import SwiftData
@testable import Lr2NewsHub

final class NewsDataActorTests: XCTestCase {
    var container: ModelContainer!
    var actor: NewsDataActor!
    
    @MainActor
    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: ArticleModel.self, configurations: config)
        
        actor = NewsDataActor(modelContainer: container)
    }

    override func tearDownWithError() throws {
        container = nil
        actor = nil
    }

    func testUpdateLibraryWithRealAPIStructs() async throws {
        let source = NewsAPIArticle.Source(id: "ID article", name: "Name article")
        
        let apiArticle = NewsAPIArticle(
            source: source,
            author: "Author article",
            title: "Title article",
            description: "Description article.",
            url: "https://url-article.com",
            urlToImage: "https://url-article/1.jpg",
            content: "Content article",
            publishedAt: "2025-12-14T17:15:00Z"
        )
        
        try await actor.updateLibrary(with: [apiArticle])
        
        let savedArticle: ArticleModel? = try await MainActor.run {
            let descriptor = FetchDescriptor<ArticleModel>()
            let results = try container.mainContext.fetch(descriptor)
            return results.first
        }
        
        XCTAssertNotNil(savedArticle)
        XCTAssertEqual(savedArticle?.title, "Title article")
        XCTAssertEqual(savedArticle?.category, "Name article")
        XCTAssertEqual(savedArticle?.published, "2025-12-14 17:15")
    }

    func testDuplicateHandling() async throws {
        let urlID = "https://test-article.com"
        
        let articleV1 = NewsAPIArticle(
            source: nil, 
            author: nil,
            title: "Old Title",
            description: nil,
            url: urlID,
            urlToImage: nil,
            content: nil,
            publishedAt: nil
        )
        
        try await actor.updateLibrary(with: [articleV1])
        
        let articleV2 = NewsAPIArticle(
            source: nil, 
            author: nil,
            title: "New Updated Title",
            description: nil,
            url: urlID,
            urlToImage: nil,
            content: nil,
            publishedAt: nil
        )
        
        try await actor.updateLibrary(with: [articleV2])
        
        let articles = try await MainActor.run {
            try container.mainContext.fetch(FetchDescriptor<ArticleModel>())
        }
        
        XCTAssertEqual(articles.count, 1, "Data not update")
        XCTAssertEqual(articles.first?.title, "New Updated Title", "Data update")
    }
    
    func testNilHandling() async throws {
        let incompleteArticle = NewsAPIArticle(
            source: nil,
            author: nil,
            title: nil,
            description: nil,
            url: "https://url-nil-article.com",
            urlToImage: nil,
            content: nil,
            publishedAt: nil
        )
        
        try await actor.updateLibrary(with: [incompleteArticle])
        
        let saved: ArticleModel? = try await MainActor.run {
            let descriptor = FetchDescriptor<ArticleModel>()
            let fetchedArticles = try container.mainContext.fetch(descriptor)
            return fetchedArticles.first
        }
        
        XCTAssertEqual(saved?.title, "Untitled")
        XCTAssertEqual(saved?.author, "Not found")
        XCTAssertEqual(saved?.category, "Not found")
    }
}
