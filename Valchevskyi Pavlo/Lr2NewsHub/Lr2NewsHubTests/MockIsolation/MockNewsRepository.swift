//
//  MockNewsRepository.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 14.12.2025.
//

import Foundation
import SwiftData
@testable import Lr2NewsHub

final class MockNewsRepository: NewsRepositoryProtocol, @unchecked Sendable {
    
    @MainActor var mockArticles: [ArticleModel] = []
    var shouldThrowError: Bool = false
    var saveCalled: Bool = false
    
    init() {
        Task { @MainActor in
            mockArticles = [
                ArticleModel(
                    id: "test-1",
                    title: "Test 1",
                    text: "Content 1",
                    category: "Category 1",
                    isFavorite: false,
                    articleUrl: "urlArticle",
                    imageUrl: "https://ichef.bbci.co.uk/news/1024/branded_news/447e/live/440a5730-c743-11f0-8c06-f5d460985095.jpg",
                    author: "Author 1",
                    published: "2021-01-01"
                ),
                ArticleModel(
                    id: "test-2",
                    title: "Test 2",
                    text: "Content 2",
                    category: "Category 2",
                    isFavorite: true,
                    author: "Aouthor 2",
                    published: "2022-02-02"
                )
            ]
        }
    }

    @MainActor
    func fetchArticles() throws -> [ArticleModel] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return mockArticles
    }

    @MainActor
    func saveContext() throws {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 2, userInfo: nil)
        }
        saveCalled = true
    }
    
    func syncRemoteNews() async throws {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
    }
    
    func clearData() async throws {
        await MainActor.run {
            mockArticles.removeAll()
        }
    }
}
