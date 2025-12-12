//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 19.11.2025.
//

import UIKit
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // Storing the container here to make it accessible app-wide.
    let container: ModelContainer
    
    override init() {
        do {
            container = try ModelContainer(for: Coin.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("✅ App Delegate is set up.")
        return true
    }
}
