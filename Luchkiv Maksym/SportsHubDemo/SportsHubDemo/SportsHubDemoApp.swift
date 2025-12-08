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
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
        }
        .modelContainer(for: GameRecord.self)
    }
}
