//
//  EventiveApp.swift
//  Eventive
//
//  Created by Anastasiia Falkovska on 30.10.2025.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
@main
struct EventiveApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Event.self)
    }
}
