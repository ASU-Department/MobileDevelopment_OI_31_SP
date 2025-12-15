//
//  ViewModel.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 22.11.2025.
//

import Foundation
import SwiftData

@MainActor
class ContentViewModel: ObservableObject {
    @Published var articles: [ArticleModel] = []
    @Published var filteredArticles: [ArticleModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: NewsRepositoryProtocol
    
    private var currentCategory: String = "All"
    private var isFavoriteOnly: Bool = false

    var availableCategories: [String] {
        let setCategories = Set(articles.map { $0.category })
        return ["All"] + setCategories.sorted()
    }
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
        loadLocalData()
    }

    func loadLocalData() {
        do {
            self.articles = try repository.fetchArticles()
            applyFilters()
        } catch {
            errorMessage = "Failed to load local storage."
        }
    }

    func fetchRemoteNews() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await repository.syncRemoteNews()
            loadLocalData()
        } catch {
            errorMessage = "Failed to update news. Showing cached data."
        }
        
        isLoading = false
    }
    
    func resetData() {
        Task {
            try? await repository.clearData()
            loadLocalData()
        }
    }
    
    func updateFilters(category: String, favoriteOnly: Bool) {
        self.currentCategory = category
        self.isFavoriteOnly = favoriteOnly
        applyFilters()
    }

    private func applyFilters() {
        let byCategory = articles.filter { currentCategory == "All" || $0.category == currentCategory }
        let final = isFavoriteOnly ? byCategory.filter { $0.isFavorite } : byCategory
        self.filteredArticles = final
    }
}
