//
//  WeatherViewModel.swift
//  WeatherWise
//
//  Created by vburdyk on 07.12.2025.
//

import Foundation
import Combine

final class WeatherViewModel: ObservableObject {
    
    @Published var temperature: Double?
    @Published var wind: Double?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service = WeatherService()
    private let lastCityKey = "last_used_city"
    		
    func loadWeather(for city: String) {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        UserDefaults.standard.set(city, forKey: self.lastCityKey)
        
        let coordinates: [String: (Double, Double)] = [
            "Львів": (49.8397, 24.0297),
            "Київ": (50.4501, 30.5234),
            "Одеса": (46.4825, 30.7233)
        ]
        
        let (lat, lon) = coordinates[city] ?? (49.8397, 24.0297)
        
        Task {
            do {
                let result = try await self.service.fetchWeather(lat: lat, lon: lon)
                
                await MainActor.run {
                    self.temperature = result.current_weather.temperature
                    self.wind = result.current_weather.windspeed
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load weather."
                    self.isLoading = false
                }
            }
        }
    }
    
    func loadLastCity() -> String {
        UserDefaults.standard.string(forKey: lastCityKey) ?? "Львів"
    }
}
