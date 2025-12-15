//
//  AppCoordinator.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 14.12.2025.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
class AppCoordinator: ObservableObject {
    let modelContainer: ModelContainer
    let repository: ArtworkRepository
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Artwork.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        let actor = ArtworkDatabaseActor(modelContext: modelContainer.mainContext)
        repository = ArtworkRepository(databaseActor: actor)
    }
    
    func makeContentView() -> some View {
        ContentView(coordinator: self)
            .modelContainer(modelContainer)
    }
    
    func makeArtworkDetailViewModel(artwork: Artwork) -> ArtworkDetailViewModel {
        ArtworkDetailViewModel(artwork: artwork, repository: repository)
    }
}
