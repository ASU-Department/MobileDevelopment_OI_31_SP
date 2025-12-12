//
//  NewsRepositoryProtocol.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 11.12.2025.
//

import Foundation
import SwiftData

protocol NewsRepositoryProtocol {
    @MainActor func fetchArticles() throws -> [ArticleModel]
    @MainActor func saveContext() throws
    
    func syncRemoteNews() async throws
    func clearData() async throws
}

class NewsRepository: NewsRepositoryProtocol {
    private let service = NewsService.shared
    private let dataActor: NewsDataActor
    private let container: ModelContainer

    init(container: ModelContainer) {
        self.dataActor = NewsDataActor(modelContainer: container)
        self.container = container
    }

    @MainActor
    func fetchArticles() throws -> [ArticleModel] {
        let descriptor = FetchDescriptor<ArticleModel>(sortBy: [SortDescriptor(\.published, order: .reverse)])
        return try container.mainContext.fetch(descriptor)
    }

    func syncRemoteNews() async throws {
        let remoteNews = try await service.fetchNews()
        try await dataActor.updateLibrary(with: remoteNews)
    }
    
    func clearData() async throws {
        try await dataActor.clearAllData()
    }
    
    @MainActor
    func saveContext() throws {
        try container.mainContext.save()
    }
}
