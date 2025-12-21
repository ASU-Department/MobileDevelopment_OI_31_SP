//
//  SportsHubDemoApp.swift
//  SportsHubDemo
//
//  Created by Maksym on 19.10.2025.
//

import Foundation
import SwiftUI
import SwiftData

@main
struct SportsHubDemoApp: App {
    private let isUITesting = ProcessInfo.processInfo.arguments.contains("UI_TESTS")

    private let container: ModelContainer = {
        if ProcessInfo.processInfo.arguments.contains("UI_TESTS") {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            do { return try ModelContainer(for: GameRecord.self, configurations: config) }
            catch { fatalError("Failed to create in-memory container: \(error)") }
        }
        do { return try ModelContainer(for: GameRecord.self) }
        catch { fatalError("Failed to create ModelContainer: \(error)") }
    }()

    private var repository: any GamesRepositoryProtocol {
        #if DEBUG
        if isUITesting {
            return MockGamesRepository(
                cachedGames: SampleData.games,
                refreshResult: .success(SampleData.games),
                lastUpdateDate: Date(timeIntervalSince1970: 0)
            )
        }
        #endif
        return DefaultGamesRepository(container: container)
    }

    init() {
        if isUITesting, let bundleId = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleId)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(container: container, repository: repository)
                .modelContainer(container)
        }
    }
}
