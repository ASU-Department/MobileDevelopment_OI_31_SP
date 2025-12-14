//
//  ContentViewModelTests.swift
//  Lr2NewsHubTests
//
//  Created by Pavlo on 14.12.2025.
//

import XCTest
@testable import Lr2NewsHub

final class ContentViewModelTests: XCTestCase {

    var viewModel: ContentViewModel!
    var mockRepo: MockNewsRepository!

    override func setUp() async throws {
        let repo = MockNewsRepository()
        self.mockRepo = repo

        let vm: ContentViewModel = await MainActor.run {
            return ContentViewModel(repository: repo)
        }
        
        self.viewModel = vm
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockRepo = nil
    }

    @MainActor
    func testInitialDataLoad() {
        viewModel.loadLocalData()
        
        XCTAssertEqual(viewModel.articles.count, 2)
        XCTAssertEqual(viewModel.articles.first?.title, "Test 1")
    }
    
    @MainActor
    func testFilterByFavorite() {
        viewModel.loadLocalData()
        
        viewModel.updateFilters(category: "All", favoriteOnly: true)
        
        XCTAssertEqual(viewModel.filteredArticles.count, 1)
        XCTAssertEqual(viewModel.filteredArticles.first?.title, "Test 2")
    }
    
    @MainActor
    func testFilterByCategory() {
        viewModel.loadLocalData()
        
        viewModel.updateFilters(category: "Category 2", favoriteOnly: false)
        
        XCTAssertEqual(viewModel.filteredArticles.count, 1)
        XCTAssertEqual(viewModel.filteredArticles.first?.category, "Category 2")
    }
    
    func testRemoteSyncFailureHandling() async {
        mockRepo.shouldThrowError = true
        
        await viewModel.fetchRemoteNews()
        
        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertEqual(viewModel.errorMessage, "Failed to update news. Showing cached data.")
            XCTAssertFalse(viewModel.isLoading)
        }
    }
    
    @MainActor
    func testAvailableCategoriesComputation() {
        viewModel.loadLocalData()
        
        let categories = viewModel.availableCategories
        
        XCTAssertTrue(categories.contains("All"))
        XCTAssertTrue(categories.contains("Category 1"))
        XCTAssertTrue(categories.contains("Category 2"))
        XCTAssertEqual(categories.count, 3, "Available All, Category 1, Category 2")
    }

    @MainActor
    func testComplexFiltering() {
        viewModel.loadLocalData()
        
        viewModel.updateFilters(category: "Category 1", favoriteOnly: true)
        XCTAssertTrue(viewModel.filteredArticles.isEmpty, "Not favorite in Category 1, list empty")
        
        viewModel.updateFilters(category: "Category 2", favoriteOnly: true)
        XCTAssertEqual(viewModel.filteredArticles.count, 1)
        XCTAssertEqual(viewModel.filteredArticles.first?.title, "Test 2")
    }

    @MainActor
    func testLoadLocalDataFailure() {
        mockRepo.shouldThrowError = true
        
        viewModel.loadLocalData()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load local storage.")
        XCTAssertTrue(viewModel.articles.isEmpty, "List empty")
    }

    func testRemoteSyncSuccess() async {
        mockRepo.shouldThrowError = false
        
        await viewModel.fetchRemoteNews()
        
        await MainActor.run {
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.articles.count, 2)
        }
    }
}
