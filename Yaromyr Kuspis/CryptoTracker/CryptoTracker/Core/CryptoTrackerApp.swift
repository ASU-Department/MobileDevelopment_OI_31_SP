//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import SwiftUI
import SwiftData

@main
struct CryptoTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
        .modelContainer(for: Coin.self)
    }
}
