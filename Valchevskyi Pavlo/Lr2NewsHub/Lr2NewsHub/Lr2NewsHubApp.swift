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
    let container: ModelContainer?
    let newsRepository: NewsRepositoryProtocol

    init() {
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        let isUITesting = CommandLine.arguments.contains("-UITest")
        
        if isUITesting || isUnitTesting {
            print("Use mock repository for test:\n")
            
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
            
            newsRepository = MockNewsRepository()
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try? ModelContainer(for: ArticleModel.self, configurations: config)
        } else {
            do {
                let realContainer = try ModelContainer(for: ArticleModel.self)
                container = realContainer
                newsRepository = NewsRepository(container: realContainer)
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            if let container = container {
                ContentView(repository: newsRepository)
                    .modelContainer(container)
            } else {
                ContentView(repository: newsRepository)
            }
        }
    }
}
