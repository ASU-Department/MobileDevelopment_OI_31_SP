//
//  AppDelegate.swift
//  SportsHubDemo
//
//  Created by Maksym on 02.11.2025.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    static weak var dataStore: AppDataStore?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        AppDelegate.dataStore?.loadMockData()
        return true
    }
}
