//
//  SportsHubDemoApp.swift
//  SportsHubDemo
//
//  Created by Maksym on 19.10.2025.
//

import SwiftUI
import SwiftData

@main
struct SportsHubDemoApp: App {
    private let container: ModelContainer = {
        do { return try ModelContainer(for: GameRecord.self) }
        catch { fatalError("Failed to create ModelContainer: \(error)") }
    }()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(container: container)
                .modelContainer(container)
        }
    }
}
