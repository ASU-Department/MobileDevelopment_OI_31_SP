//
//  QuizWhizApp.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 25.11.2025.
//

import SwiftUI
import SwiftData
import Combine

@main
struct QuizWhizApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let sharedModelContainer: ModelContainer = {
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
    
    @StateObject private var coordinator: AppCoordinator = {
        let container: ModelContainer = {
            let schema = Schema([PersistedQuestion.self])
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
        return AppCoordinator(modelContainer: container)
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                coordinator.makeRootView()
            }
            .modelContainer(sharedModelContainer)
            .environmentObject(coordinator)
        }
    }
}
