//
//  Task1App.swift
//  Task1
//
//  Created by v on 17.10.2025.
//

import SwiftUI

@main
struct Task1App: App {
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class MyAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        BookStore.shared.loadMock()
        return true
    }
}
