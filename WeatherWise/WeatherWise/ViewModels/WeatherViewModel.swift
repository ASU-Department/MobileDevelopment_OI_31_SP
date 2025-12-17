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
    
    private let repository = WeatherRepository()
    
    private let coordinatesByCity: [String: (Double, Double)] = [
        "Львів": (49.8397, 24.0297),
        "Київ": (50.4501, 30.5234),
        "Одеса": (46.4825, 30.7233)
    ]
    
    func loadWeather(for city: String, context: ModelContext) {
        isLoading = true
        errorMessage = nil
        
        let coordinates = coordinatesByCity[city] ?? (49.8397, 24.0297)
        
        Task {
            let result = await repository.loadWeather(for: city,
                                                      coordinates: coordinates,
                                                      context: context)
            isLoading = false
            
            switch result {
            case .success(let values):
                temperature = values.0
                wind = values.1
                
            case .failure(let error):
                errorMessage = "Не вдалося завантажити погоду: \(error.localizedDescription)"
            }
        }
    }
}
