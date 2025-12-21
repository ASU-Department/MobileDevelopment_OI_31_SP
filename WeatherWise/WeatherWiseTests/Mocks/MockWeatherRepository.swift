//
//  MockWeatherRepository.swift
//  WeatherWise
//
//  Created by vburdyk on 17.12.2025.
//

@testable import WeatherWise
import Foundation

final class MockWeatherRepository: WeatherRepositoryProtocol {

    enum Result {
        case success(Double, Double)
        case failure(Error)
    }

    var result: Result?
    private(set) var requestedCity: String?

    func loadWeather(
        for city: String
    ) async throws -> (temperature: Double, wind: Double) {

        requestedCity = city

        guard let result = result else {
            fatalError("Mock result not set")
        }

        switch result {
        case .success(let temp, let wind):
            return (temperature: temp, wind: wind)

        case .failure(let error):
            throw error
        }
    }
}
