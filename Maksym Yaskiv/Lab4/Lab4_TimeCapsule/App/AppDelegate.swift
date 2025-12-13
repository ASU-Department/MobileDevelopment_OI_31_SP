//
//  AppDelegate.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        print("TimeCapsule has launched!")
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.8, alpha: 1.0)
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.brown,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.brown
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        return true
    }
}