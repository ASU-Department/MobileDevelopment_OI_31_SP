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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: City.self)
    }
}
