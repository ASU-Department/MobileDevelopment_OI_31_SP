//
//  WeatherWiseApp.swift
//  WeatherWise
//
//  Created by vburdyk on 22.11.2025.
//

import SwiftUI
import SwiftData

@main
struct WeatherWiseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedWeather.self)
    }
}
