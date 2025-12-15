//
//  CityModel.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftData
import SwiftUI

@Model
class City {
    @Attribute(.unique) var id: UUID
    var name: String
    var aqi: Int
    var pm25: Double
    var o3: Double
    var selected: Bool

    init(
        name: String,
        aqi: Int = 0,
        pm25: Double = 0,
        o3: Double = 0,
        selected: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.aqi = aqi
        self.pm25 = pm25
        self.o3 = o3
        self.selected = selected
    }

    var healthAdvice: String {
        switch aqi {
            case 0..<50: return "Good air quality"
            case 50..<100: return "Moderate air quality"
            case 100..<150: return "Unhealthy for sensitive groups"
            case 150..<200: return "Unhealthy for everyone"
            default: return "Very dangerous"
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

extension City {
    static func fromAPI(name: String, _ data: AQCoreData) -> City {
        City(
            name: name,
            aqi: data.aqi ?? 0,
            pm25: data.iaqi?.pm25?.v ?? 0,
            o3: data.iaqi?.o3?.v ?? 0
        )
    }

    func updateFromAPI(_ data: AQCoreData) {
        self.aqi = data.aqi ?? self.aqi
        self.pm25 = data.iaqi?.pm25?.v ?? self.pm25
        self.o3 = data.iaqi?.o3?.v ?? self.o3
    }
}

