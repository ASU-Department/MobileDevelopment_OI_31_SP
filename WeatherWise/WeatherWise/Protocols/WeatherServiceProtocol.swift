//
//  WeatherServiceProtocol.swift
//  WeatherWise
//
//  Created by vburdyk on 17.12.2025.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse
}
