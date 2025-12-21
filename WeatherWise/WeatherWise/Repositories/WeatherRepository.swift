//
//  WeatherRepository.swift
//  WeatherWise
//
//  Created by vburdyk on 15.12.2025.
//

import Foundation
import SwiftData

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private let service = WeatherService()
    
    private let coordinatesByCity: [String: (Double, Double)] = [
        "Львів": (49.8397, 24.0297),
        "Київ": (50.4501, 30.5234),
        "Одеса": (46.4825, 30.7233)
    ]
    
    func loadWeather(for city: String) async throws -> (temperature: Double, wind: Double) {
        let coordinates = coordinatesByCity[city] ?? (49.8397, 24.0297)
        let (lat, lon) = coordinates
        
        let response = try await service.fetchWeather(lat: lat, lon: lon)
        let temp = response.current_weather.temperature
        let wind = response.current_weather.windspeed
        
        return (temperature: temp, wind: wind)
    }
    
    func loadWeather(for city: String,
                     coordinates: (Double, Double),
                     context: ModelContext) async -> Result<(Double, Double), Error> {
        
        let storage = WeatherStorageActor(context: context)
        let (lat, lon) = coordinates
        
        do {
            let response = try await service.fetchWeather(lat: lat, lon: lon)
            let temp = response.current_weather.temperature
            let wind = response.current_weather.windspeed
            
            try await storage.saveWeather(city: city,
                                          temperature: temp,
                                          wind: wind)
            
            return .success((temp, wind))
            
        } catch {
            do {
                if let saved = try await storage.fetchSavedWeather(city: city) {
                    return .success((saved.temperature, saved.wind))
                }
            } catch {
            }
            return .failure(error)
        }
    }
}
