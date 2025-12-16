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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let container: ModelContainer
    let actor: HistoryDataActor
    let repository: any TimeCapsuleRepositoryProtocol
    
    init() {
        do {
            container = try ModelContainer(for: HistoricalEvent.self)
            actor = HistoryDataActor(modelContainer: container)
            repository = TimeCapsuleRepository(actor: actor)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(repository: repository)
        }
    }
}