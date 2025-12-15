//
//  WeatherViewModel.swift
//  WeatherWise
//
//  Created by vburdyk on 07.12.2025.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class WeatherViewModel: ObservableObject {
    
    @Published var temperature: Double?
    @Published var wind: Double?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = WeatherService()
    
    func loadWeather(for city: String, context: ModelContext) {
        isLoading = true
        errorMessage = nil
        
        let coordinates: [String: (Double, Double)] = [
            "Львів": (49.8397, 24.0297),
            "Київ": (50.4501, 30.5234),
            "Одеса": (46.4825, 30.7233)
        ]
        
        let (lat, lon) = coordinates[city] ?? (49.8397, 24.0297)
        
        Task {
            do {
                let result = try await service.fetchWeather(lat: lat, lon: lon)
                
                self.temperature = result.current_weather.temperature
                self.wind = result.current_weather.windspeed
                self.isLoading = false
                
                let request = FetchDescriptor<SavedWeather>(
                    predicate: #Predicate { $0.city == city }
                )
                
                if let existing = try? context.fetch(request).first {
                    existing.temperature = result.current_weather.temperature
                    existing.wind = result.current_weather.windspeed
                } else {
                    let saved = SavedWeather(
                        city: city,
                        temperature: result.current_weather.temperature,
                        wind: result.current_weather.windspeed
                    )
                    context.insert(saved)
                }
            } catch {
                print("Error fetching weather: \(error)")
                
                let request = FetchDescriptor<SavedWeather>(
                    predicate: #Predicate { $0.city == city }
                )
                
                if let saved = try? context.fetch(request).first {
                    self.temperature = saved.temperature
                    self.wind = saved.wind
                    self.errorMessage = "Offline mode: showing saved data"
                } else {
                    self.errorMessage = "Failed to load weather: \(error.localizedDescription)"
                }

                self.isLoading = false
            }
        }
    }
}
