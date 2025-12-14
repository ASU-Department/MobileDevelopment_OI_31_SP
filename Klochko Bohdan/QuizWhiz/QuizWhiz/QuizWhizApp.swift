//
//  QuizWhizApp.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 25.11.2025.
//

import SwiftUI
import SwiftData

@main
struct QuizWhizApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            QuizSettingsView()
        }
        .modelContainer(sharedModelContainer)
    }
}
