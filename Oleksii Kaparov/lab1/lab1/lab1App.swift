//
//  lab1App.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import SwiftUI

@main
struct lab1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            FitTrackerView()
        }
    }
}
