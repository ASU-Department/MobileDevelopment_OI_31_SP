//
//  CityRepositoryTest.swift
//  lab1
//
//  Created by witold on 15.12.2025.
//

import XCTest
import SwiftData
@testable import lab1

final class CityRepositoryTests: XCTestCase {
    var sut: CityRepository!
    var mockNetworkService: MockNetworkService!
    var persistenceActor: CityPersistenceActor!
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    
    override func setUp() async throws {
        try await super.setUp()
        
        let schema = Schema([City.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [config])
        modelContext = ModelContext(modelContainer)
        
        persistenceActor = CityPersistenceActor(modelContext: modelContext)
        
        mockNetworkService = MockNetworkService()
        
        sut = await CityRepository(
            networkService: mockNetworkService,
            persistenceActor: persistenceActor
        )
    }
    
    override func tearDown() async throws {
        sut = nil
        persistenceActor = nil
        modelContext = nil
        modelContainer = nil
        mockNetworkService = nil
        try await super.tearDown()
    }
    
    func testFetchAQI_Success() async throws {
        let expectedData = AQCoreData(
            aqi: 55,
            iaqi: IAQI(pm25: AQValue(v: 15.0), o3: nil)
        )
        mockNetworkService.dataToReturn = expectedData
        
        let result = try await sut.fetchAQI(for: "Kyiv")
        
        XCTAssertEqual(mockNetworkService.fetchCallCount, 1)
        XCTAssertEqual(mockNetworkService.lastCityRequested, "Kyiv")
        XCTAssertEqual(result.aqi, 55)
    }
    
    func testRefreshAllCities_NewCityAdded() async throws {
        mockNetworkService.dataToReturn = AQCoreData(aqi: 40, iaqi: nil)
        
        try await sut.refreshAllCities()
        
        let cities = try await persistenceActor.fetchAllCities()
        XCTAssertGreaterThan(cities.count, 0, "Should insert new cities")
    }
    
    func testSearchAndAddCity_NewCity() async throws {
        mockNetworkService.dataToReturn = AQCoreData(aqi: 50, iaqi: nil)
        
        try await sut.searchAndAddCity(name: "Warsaw")

        let city = try await persistenceActor.fetchCity(byName: "Warsaw")
        XCTAssertNotNil(city)
        XCTAssertEqual(city?.name, "Warsaw")
        XCTAssertEqual(city?.aqi, 50)
        XCTAssertEqual(mockNetworkService.lastCityRequested, "Warsaw")
    }
    
    func testSearchAndAddCity_ExistingCity_Updates() async throws {
        let existingCity = City(name: "Kyiv", aqi: 30)
        try await persistenceActor.insertCity(existingCity)
        
        mockNetworkService.dataToReturn = AQCoreData(
            aqi: 60,
            iaqi: IAQI(pm25: AQValue(v: 18.0), o3: AQValue(v: 35.0))
        )
        
        try await sut.searchAndAddCity(name: "Kyiv")
        
        let cities = try await persistenceActor.fetchAllCities()
        XCTAssertEqual(cities.count, 1, "Should update existing city, not add new")
        
        let updatedCity = try await persistenceActor.fetchCity(byName: "Kyiv")
        XCTAssertEqual(updatedCity?.aqi, 60, "AQI should be updated")
    }
    
    func testClearAllCities() async throws {
        try await persistenceActor.insertCity(City(name: "City1", aqi: 10))
        try await persistenceActor.insertCity(City(name: "City2", aqi: 20))
        
        try await sut.clearAllCities()
        
        let cities = try await persistenceActor.fetchAllCities()
        XCTAssertTrue(cities.isEmpty, "All cities should be deleted")
    }
    
    func testRefreshAllCities_NetworkError() async {
        mockNetworkService.shouldFail = true
        
        do {
            try await sut.refreshAllCities()
            XCTFail("Should throw error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testGetCities() async throws {
        try await persistenceActor.insertCity(City(name: "Kyiv", aqi: 45))
        try await persistenceActor.insertCity(City(name: "Lviv", aqi: 30))
        
        let cities = try await sut.getCities()
        
        XCTAssertEqual(cities.count, 2)
        XCTAssertTrue(cities.contains { $0.name == "Kyiv" })
        XCTAssertTrue(cities.contains { $0.name == "Lviv" })
    }
    
    func testUpdateCitySubscription() async throws {
        let city = City(name: "Warsaw", aqi: 35, selected: false)
        try await persistenceActor.insertCity(city)
        
        try await sut.updateCitySubscription(city: city, isSelected: true)
        
        let updatedCity = try await persistenceActor.fetchCity(byName: "Warsaw")
        XCTAssertTrue(updatedCity?.selected ?? false, "City should be selected")
    }
}
