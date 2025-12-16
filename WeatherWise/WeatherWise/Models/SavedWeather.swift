//
//  SavedWeather.swift
//  WeatherWise
//
//  Created by vburdyk on 14.12.2025.
//

import SwiftData

@Model
class SavedWeather {
    var city: String
    var temperature: Double
    var wind: Double
    
    init(city: String, temperature: Double, wind: Double) {
        self.city = city
        self.temperature = temperature
        self.wind = wind
    }
}
