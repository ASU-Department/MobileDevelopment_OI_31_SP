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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PersistedQuestion.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true,
            cloudKitDatabase: .none
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                QuizSettingsView()
            }
            .modelContainer(sharedModelContainer)
        }
    }
}
