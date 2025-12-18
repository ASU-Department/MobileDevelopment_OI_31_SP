//
//  CityListViewModel.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

import Combine
import Foundation

@MainActor
final class CityListViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var lastUpdate = ""
    
    private let repository: CityRepositoryProtocol
    weak var coordinator: AppCoordinator?
    
    init(repository: CityRepositoryProtocol) {
        self.repository = repository
    }
    
    var sortedCities: [City] {
        let curr = cities.first { $0.name == "Your location" }
        let subscribed = cities.filter { $0.selected && $0.name != "Your location" }
        let others = cities.filter { !$0.selected && $0.name != "Your location" }
        
        var result: [City] = []
        if let curr = curr {
            result.append(curr)
        }
        result.append(contentsOf: subscribed)
        result.append(contentsOf: others)
        return result
    }
    
    func refreshCities() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await repository.refreshAllCities()
            cities = try await repository.getCities()
            lastUpdate = Date().formatted(date: .numeric, time: .shortened)
        } catch {
            errorMessage = "Failed to load cities. Showing local data."
        }
        
        isLoading = false
    }
    
    func searchCity() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await repository.searchAndAddCity(name: searchText)
            cities = try await repository.getCities()
            searchText = ""
        } catch {
            errorMessage = "Failed to find city: \(searchText)"
        }
        
        isLoading = false
    }
    
    func clearAllCities() async {
        do {
            try await repository.clearAllCities()
            cities = []
            lastUpdate = "None"
        } catch {
            errorMessage = "Failed to clear cities"
        }
    }
    
    func navigateToCityDetail(_ city: City) {
        coordinator?.showCityDetail(city: city)
    }
    
    func loadCities() async {
        do {
            cities = try await repository.getCities()
        } catch {
            print("Failed to load cities: \(error)")
        }
    }
}
