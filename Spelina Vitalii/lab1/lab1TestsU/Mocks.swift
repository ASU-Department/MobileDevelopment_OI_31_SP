//
//  MockNetworkService.swift
//  lab1
//
//  Created by witold on 17.12.2025.
//

import Foundation
import SwiftData

@testable import lab1

final class MockNetworkService: NetworkServiceProtocol {
    var shouldFail = false
    var dataToReturn: AQCoreData?
    var errorToThrow: Error?
    var fetchCallCount = 0
    var lastCityRequested: String?
    
    func fetchAQI(for city: String) async throws -> AQCoreData {
        fetchCallCount += 1
        lastCityRequested = city
        
        if let error = errorToThrow {
            throw error
        }
        
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        
        return dataToReturn ?? AQCoreData(aqi: 50, iaqi: IAQI(pm25: AQValue(v: 12.5), o3: AQValue(v: 25.0)))
    }
}

final class MockCityRepository: CityRepositoryProtocol {
    var shouldFail = false
    var citiesToReturn: [City] = []
    var aqiDataToReturn: AQCoreData?
    var errorToThrow: Error?
    
    var refreshCallCount = 0
    var searchCallCount = 0
    var clearCallCount = 0
    var getCitiesCallCount = 0
    var updateSubscriptionCallCount = 0
    
    func fetchAQI(for cityName: String) async throws -> AQCoreData {
        if let error = errorToThrow {
            throw error
        }
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return aqiDataToReturn ?? AQCoreData(aqi: 50, iaqi: nil)
    }
    
    func refreshAllCities() async throws {
        refreshCallCount += 1
        try await Task.sleep(nanoseconds: 50_000_000)
        if shouldFail {
            throw URLError(.badServerResponse)
        }
    }
    
    func searchAndAddCity(name: String) async throws {
        searchCallCount += 1
        if shouldFail {
            throw URLError(.badServerResponse)
        }
    }
    
    func clearAllCities() async throws {
        clearCallCount += 1
        if shouldFail {
            throw NSError(domain: "ClearError", code: 1)
        }
        citiesToReturn.removeAll()
    }
    
    @MainActor
    func updateCitySubscription(city: City, isSelected: Bool) async throws {
        updateSubscriptionCallCount += 1
        if shouldFail {
            throw NSError(domain: "UpdateError", code: 1)
        }
        city.selected = isSelected
    }
    
    @MainActor
    func getCities() async throws -> [City] {
        getCitiesCallCount += 1
        if shouldFail {
            throw NSError(domain: "GetCitiesError", code: 1)
        }
        return citiesToReturn
    }
}
