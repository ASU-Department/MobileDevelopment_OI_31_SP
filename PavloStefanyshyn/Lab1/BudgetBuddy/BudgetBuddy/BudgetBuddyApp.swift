//
//  BudgetBuddyApp.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI
import CoreData

@main
struct BudgetBuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
