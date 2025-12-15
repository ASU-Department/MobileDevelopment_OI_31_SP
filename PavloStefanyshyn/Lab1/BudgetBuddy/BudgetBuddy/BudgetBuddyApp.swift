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

    private let coordinator = AppCoordinators()

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: [ExpenseEntity.self])
        }
    }
}

struct RootView: View {
    @Environment(\.modelContext) private var context
        @StateObject private var coordinator = AppCoordinators()

        var body: some View {
            ContentView()
                .environmentObject(coordinator)
        }
}
