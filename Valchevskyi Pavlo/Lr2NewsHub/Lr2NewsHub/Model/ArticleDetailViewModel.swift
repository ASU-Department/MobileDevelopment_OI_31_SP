//
//  ArticleDetailViewModel.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 11.12.2025.
//

import Foundation
import Combine

@MainActor
class ArticleDetailViewModel: ObservableObject {
    @Published var article: ArticleModel
    private let repository: NewsRepositoryProtocol

    init(article: ArticleModel, repository: NewsRepositoryProtocol) {
        self.article = article
        self.repository = repository
    }
    
    func toggleFavorite() {
        article.isFavorite.toggle()
        saveChanges()
    }

    func updateRating(to value: Int) {
        article.userPoint = value
        saveChanges()
    }
    
    private func saveChanges() {
        try? repository.saveContext()
    }
}
