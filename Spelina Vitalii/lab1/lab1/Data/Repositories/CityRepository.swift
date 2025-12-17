//
//  CityRepository.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

final class CityRepository: CityRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let persistenceActor: CityPersistenceActor
    
    private let defaultCities = [
        "Your location",
        "Kyiv",
        "Lviv",
        "Odesa",
        "Dnipro",
        "Warsaw",
        "Krakow",
        "New York",
        "Tokyo",
        "New Delhi"
    ]
    
    init(networkService: NetworkServiceProtocol, persistenceActor: CityPersistenceActor) {
        self.networkService = networkService
        self.persistenceActor = persistenceActor
    }
    
    func fetchAQI(for cityName: String) async throws -> AQCoreData {
        try await networkService.fetchAQI(for: cityName)
    }
    
    func refreshAllCities() async throws {
        var firstError: Error?
        
        for name in defaultCities {
            do {
                let cityNameForAPI = name == "Your location" ? "here" : name
                let apiData = try await networkService.fetchAQI(for: cityNameForAPI)
                
                if let existingCity = try await persistenceActor.fetchCity(byName: name) {
                    try await persistenceActor.updateCity(existingCity, with: apiData)
                } else {
                    let newCity = City.fromAPI(name: name, apiData)
                    try await persistenceActor.insertCity(newCity)
                }
            } catch {
                print("Failed loading city \(name): \(error)")
                if firstError == nil {
                    firstError = error
                }
            }
        }
        
        if let errorToThrow = firstError {
            throw errorToThrow
        }
    }
    
    func searchAndAddCity(name: String) async throws {
        let apiData = try await networkService.fetchAQI(for: name)
        
        if let existingCity = try await persistenceActor.fetchCity(byName: name) {
            try await persistenceActor.updateCity(existingCity, with: apiData)
        } else {
            let newCity = City.fromAPI(name: name, apiData)
            try await persistenceActor.insertCity(newCity)
        }
    }
    
    func clearAllCities() async throws {
        try await persistenceActor.deleteAllCities()
    }
    
    func updateCitySubscription(city: City, isSelected: Bool) async throws {
        city.selected = isSelected
        try await persistenceActor.save()
    }
    
    func getCities() async throws -> [City] {
        try await persistenceActor.fetchAllCities()
    }
}
