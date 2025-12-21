//
//  TimeCapsuleApp.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import SwiftData

@main
struct TimeCapsuleApp: App {
    
    let repository: any TimeCapsuleRepositoryProtocol
    let container: ModelContainer
    
    private let isUITesting = ProcessInfo.processInfo.arguments.contains("UI_TESTS")
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        do {
            if isUITesting {
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                container = try ModelContainer(for: HistoricalEvent.self, configurations: config)
                repository = UITestStubRepository()
            } else {
                container = try ModelContainer(for: HistoricalEvent.self)
                let actor = HistoryDataActor(modelContainer: container)
                repository = TimeCapsuleRepository(actor: actor)
            }
        } catch {
            fatalError("Failed to initialize App: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(repository: repository)
        }
        .modelContainer(container)
    }
}