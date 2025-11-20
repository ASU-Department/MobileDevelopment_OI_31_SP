//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 19.11.2025.
//

import UIKit
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // A helper for debugging
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        print("✅ Core Data DB Path: \(urls[urls.count-1] as URL)")
        
        return true
    }
}
