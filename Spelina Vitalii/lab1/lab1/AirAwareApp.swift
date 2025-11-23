//
//  lab1App.swift
//  lab1
//
//  Created by witold on 06.11.2025.
//

import SwiftUI

@main
struct AirAwareApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var cityStore = CityStore()

    init() {
        _cityStore = StateObject(wrappedValue: AppDelegate.cityStore ?? CityStore())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cityStore)
        }
    }
}
