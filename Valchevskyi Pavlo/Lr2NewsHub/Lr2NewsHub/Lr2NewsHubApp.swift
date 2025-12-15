//
//  Lr2NewsHubApp.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import SwiftUI
import SwiftData

@main
struct Lr2NewsHubApp: App {
    let container: ModelContainer
    let newsRepository: NewsRepository

    init() {
        do {
            container = try ModelContainer(for: ArticleModel.self)
            newsRepository = NewsRepository(container: container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(repository: newsRepository)
        }
        .modelContainer(container)
    }
}
