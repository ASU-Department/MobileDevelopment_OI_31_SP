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
            let isUITest = ProcessInfo.processInfo.arguments.contains("-UITest")
            let schema = Schema([Coin.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isUITest)
            
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Seed data for UI Tests
        if ProcessInfo.processInfo.arguments.contains("-UITest") {
            let context = container.mainContext
            let bitcoin = Coin(
                id: "bitcoin",
                symbol: "btc",
                name: "Bitcoin",
                image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
                currentPrice: 50000.0,
                priceChangePercentage24h: 2.5,
                isFavorite: false
            )
            context.insert(bitcoin)
            try? context.save()
            print("✅ Data seeded for UI Test")
        }
        print("✅ App Delegate is set up.")
        return true
    }
}
