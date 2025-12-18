//
//  ArticleDetailViewModelTests.swift
//  Lr2NewsHubTests
//
//  Created by Pavlo on 14.12.2025.
//

import XCTest
@testable import Lr2NewsHub

final class ArticleDetailViewModelTests: XCTestCase {
    @MainActor
    func testToggleFavorite() {
        let mockRepo = MockNewsRepository()
        
        let firstArticle = ArticleModel(
            id: "test-1",
            title: "Test 1",
            text: "Content 1",
            category: "Category 1",
            isFavorite: false,
            author: "Author 1",
            published: "2021-01-01"
        )
        
        mockRepo.mockArticles = [firstArticle]
        
        let viewModel = ArticleDetailViewModel(article: firstArticle, repository: mockRepo)
        
        viewModel.toggleFavorite()
        
    
        XCTAssertTrue(viewModel.article.isFavorite, "Article is favorite")
        
        viewModel.toggleFavorite()
        
        XCTAssertFalse(viewModel.article.isFavorite, "Article is not favorite")
    }

    @MainActor
    func testRatingUpdate() {
        let mockRepo = MockNewsRepository()
        
        let firstArticle = ArticleModel(
            id: "test-1",
            title: "Test 1",
            text: "Content 1",
            category: "Category 1",
            isFavorite: false,
            author: "Author 1",
            published: "2021-01-01"
        )
        
        let viewModel = ArticleDetailViewModel(article: firstArticle, repository: mockRepo)
        
        viewModel.updateRating(to: 5)
        
        XCTAssertEqual(viewModel.article.userPoint, 5, "UserPoint is 5")
    }
}
