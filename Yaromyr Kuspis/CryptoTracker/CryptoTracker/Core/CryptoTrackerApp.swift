//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import SwiftUI
import CoreData

@main
struct CryptoTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared
    
    @State private var isShowingSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !isShowingSplash {
                    CryptoListView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .transition(.opacity.animation(.easeIn(duration: 0.5)))
                }
                
                if isShowingSplash {
                    SplashScreenView(isActive: $isShowingSplash)
                        .transition(.opacity.animation(.easeOut(duration: 0.5)))
                }
            }
        }
    }
}
