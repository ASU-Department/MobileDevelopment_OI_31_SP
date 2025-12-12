//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import SwiftUI
import SwiftData

@main
struct CryptoTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView(container: appDelegate.container)
        }
    }
}

struct RootView: View {
    let repository: CoinRepositoryProtocol
    
    init(container: ModelContainer) {
        let actor = CoinPersistenceActor(modelContainer: container)
        let service = CoinGeckoService()
        self.repository = CoinRepository(service: service, actor: actor)
    }
    
    var body: some View {
        LaunchView(repository: repository)
    }
}
