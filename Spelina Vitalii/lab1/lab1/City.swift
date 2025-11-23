//
//  CityModel.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftUI

struct City: Identifiable {
    let id = UUID()
    let name: String
    var aqi: Int
    var pm25: Float
    var o3: Float
    var selected: Bool = false
    var note: String = ""
    var healthAdvice: String {
        switch aqi {
            case 0..<50: return "Goog air quality"
            case 50..<100: return "Moderate condition, sensitive people should be more careful"
            case 100..<150: return "May be dangerous for some groups"
            case 150..<200: return "Unhealthy for everyone"
            default: return "Dangerous"
        }
    }
    var color: Color {
        switch aqi {
            case 0..<50: return .green
            case 50..<100: return .yellow
            case 100..<150: return .orange
            case 150..<200: return .red
            default: return .purple
        }
    }
}
