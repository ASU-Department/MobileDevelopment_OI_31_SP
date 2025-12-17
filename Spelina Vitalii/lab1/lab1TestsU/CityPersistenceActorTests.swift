//
//  CityPersistenceActorTests.swift
//  lab1TestsU
//
//  Created by witold on 17.12.2025.
//

import XCTest
@testable import lab1
import SwiftData

final class CityPersistenceActorTests: XCTestCase {
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    var sut: CityPersistenceActor!
    
    override func setUp() async throws {
        try await super.setUp()
        
        let schema = Schema([City.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [config])
        modelContext = ModelContext(modelContainer)
        sut = CityPersistenceActor(modelContext: modelContext)
    }
    
    override func tearDown() async throws {
        sut = nil
        modelContext = nil
        modelContainer = nil
        try await super.tearDown()
    }

    func testInsertCity_ThenFetch() async throws {
        let city = City(name: "Kyiv", aqi: 45)
        
        try await sut.insertCity(city)
        let fetchedCity = try await sut.fetchCity(byName: "Kyiv")
        
        XCTAssertNotNil(fetchedCity)
        XCTAssertEqual(fetchedCity?.name, "Kyiv")
        XCTAssertEqual(fetchedCity?.aqi, 45)
    }
    
    func testUpdateCity() async throws {
        let city = City(name: "Lviv", aqi: 30)
        try await sut.insertCity(city)
        
        let updatedData = AQCoreData(aqi: 50, iaqi: IAQI(pm25: AQValue(v: 20.0), o3: nil))
        
        try await sut.updateCity(city, with: updatedData)
        let fetchedCity = try await sut.fetchCity(byName: "Lviv")
        
        XCTAssertEqual(fetchedCity?.aqi, 50)
        XCTAssertEqual(fetchedCity?.pm25, 20.0)
    }
    
    func testFetchAllCities() async throws {
        let city1 = City(name: "Kyiv", aqi: 45)
        let city2 = City(name: "Lviv", aqi: 30)
        try await sut.insertCity(city1)
        try await sut.insertCity(city2)
        
        let cities = try await sut.fetchAllCities()
        
        XCTAssertEqual(cities.count, 2)
    }

    func testDeleteAllCities() async throws {
        try await sut.insertCity(City(name: "Test1", aqi: 10))
        try await sut.insertCity(City(name: "Test2", aqi: 20))
        
        try await sut.deleteAllCities()
        let cities = try await sut.fetchAllCities()
        
        XCTAssertTrue(cities.isEmpty)
    }

    func testConcurrentInserts_ThreadSafety() async throws {
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let city = City(name: "City\(i)", aqi: i * 10)
                    try? await self.sut.insertCity(city)
                }
            }
        }
        
        let cities = try await sut.fetchAllCities()
        XCTAssertEqual(cities.count, 10, "All concurrent inserts should succeed")
    }
}
