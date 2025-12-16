//
//  ArtCuratorApp.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import SwiftUI
import SwiftData

@main
struct ArtCuratorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.makeContentView()
        }
    }
}
