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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataStore = AppDataStore()
    
    init() {
        AppDelegate.dataStore = dataStore
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
        .modelContainer(for: GameRecord.self)
    }
}
