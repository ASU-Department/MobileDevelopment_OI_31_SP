//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import SwiftUI
import CoreData

@main
struct CryptoTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CryptoListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
