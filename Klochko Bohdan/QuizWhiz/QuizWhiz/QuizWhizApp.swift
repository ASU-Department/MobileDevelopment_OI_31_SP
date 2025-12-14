//
//  QuizWhizApp.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 25.11.2025.
//

import SwiftUI
import SwiftData

@main
struct QuizWhizApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                QuizSettingsView()
            }
        }
    }
}
