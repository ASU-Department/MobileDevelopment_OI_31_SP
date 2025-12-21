//
//  lab1App.swift
//  lab1
//
//  Created by witold on 06.11.2025.
//

import SwiftUI
import SwiftData

@main
struct AirAwareApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(modelContext: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
    
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([City.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

#Preview {
    let container = try! ModelContainer(for: City.self)
    return RootView(modelContext: container.mainContext)
        .modelContainer(container)
}
