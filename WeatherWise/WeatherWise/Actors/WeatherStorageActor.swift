//
//  WeatherStorageActor.swift
//  WeatherWise
//
//  Created by vburdyk on 15.12.2025.
//

import Foundation
import SwiftData

actor WeatherStorageActor {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchSavedWeather(city: String) throws -> SavedWeather? {
        let descriptor = FetchDescriptor<SavedWeather>()
        let all = try context.fetch(descriptor)
        return all.first { $0.city == city }
    }
    
    func saveWeather(city: String, temperature: Double, wind: Double) throws {
        if let existing = try fetchSavedWeather(city: city) {
            existing.temperature = temperature
            existing.wind = wind
        } else {
            let saved = SavedWeather(city: city,
                                     temperature: temperature,
                                     wind: wind)
            context.insert(saved)
        }
    }
}
