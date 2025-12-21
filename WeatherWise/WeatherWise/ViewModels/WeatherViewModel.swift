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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: WeatherRepositoryProtocol
    
    private let coordinatesByCity: [String: (Double, Double)] = [
        "Львів": (49.8397, 24.0297),
        "Київ": (50.4501, 30.5234),
        "Одеса": (46.4825, 30.7233)
    ]
    
    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }
    
    func loadWeather(for city: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await repository.loadWeather(for: city)
            temperature = result.temperature
            wind = result.wind
            isLoading = false
        } catch {
            errorMessage = "Не вдалося завантажити погоду: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
