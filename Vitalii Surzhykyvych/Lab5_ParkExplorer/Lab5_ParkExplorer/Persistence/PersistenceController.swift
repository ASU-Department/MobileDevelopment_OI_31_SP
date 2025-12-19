//
//  PersistenceController.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import SwiftData

final class PersistenceController {

    static let shared = PersistenceController()

    let container: ModelContainer

    private init() {
        do {
            container = try ModelContainer(for: ParkEntity.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
