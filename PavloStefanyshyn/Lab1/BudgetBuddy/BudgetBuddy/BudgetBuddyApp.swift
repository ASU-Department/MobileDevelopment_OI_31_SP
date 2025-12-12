//
//  BudgetBuddyApp.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI
import SwiftData

@main
struct BudgetBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [ExpenseEntity.self])
        }
    }
}
