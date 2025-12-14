//
//  CityDetailsViewModel.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

import Combine
import Foundation

@MainActor
final class CityDetailsViewModel: ObservableObject {
    @Published var city: City
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: CityRepositoryProtocol
    
    init(city: City, repository: CityRepositoryProtocol) {
        self.city = city
        self.repository = repository
    }
    
    func refreshCityData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let apiData = try await repository.fetchAQI(for: city.name)
            city.updateFromAPI(apiData)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func toggleSubscription() async {
        city.selected.toggle()
        
        do {
            try await repository.updateCitySubscription(city: city, isSelected: city.selected)
        } catch {
            city.selected.toggle()
            errorMessage = "Failed to update subscription"
        }
    }
}
