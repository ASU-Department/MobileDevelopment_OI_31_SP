//
//  WeatherRepositoryProtocol.swift
//  WeatherWise
//
//  Created by vburdyk on 17.12.2025.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func loadWeather(
        for city: String
    ) async throws -> (temperature: Double, wind: Double)
}
