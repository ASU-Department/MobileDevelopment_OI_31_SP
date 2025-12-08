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
            ContentView(viewModel: GamesViewModel(repository: DefaultGamesRepository()))
        }
        .modelContainer(for: GameRecord.self)
    }
}
