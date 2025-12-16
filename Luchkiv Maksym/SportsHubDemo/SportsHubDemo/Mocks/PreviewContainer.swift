//
//  PreviewContainer.swift
//  SportsHubDemo
//
//  Created by Maksym on 08.12.2025.
//

import SwiftData

enum PreviewContainer {
    static let shared: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            return try ModelContainer(for: GameRecord.self, configurations: config)
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }()
}
