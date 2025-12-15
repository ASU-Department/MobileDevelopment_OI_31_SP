//
//  habitBuddyApp.swift
//  habitBuddy
//
//  Created by paul on 17.10.2025.
//

import SwiftData
import SwiftUI

@main
struct habitBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Habit.self)
        }
    }
}
