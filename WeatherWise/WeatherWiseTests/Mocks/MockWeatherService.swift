//
//  MockWeatherService.swift
//  WeatherWise
//
//  Created by vburdyk on 17.12.2025.
//

@testable import WeatherWise
import Foundation

final class MockWeatherService: WeatherServiceProtocol {

    enum Result {
        case success(Double, Double)
        case failure(Error)
    }

    var result: Result?

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        switch result {
        case .success(let temp, let wind):
            return WeatherResponse(
                latitude: lat,
                longitude: lon,
                current_weather: CurrentWeather(
                    temperature: temp,
                    windspeed: wind,
                    weathercode: 0
                )
            )
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set")
        }
    }
}
