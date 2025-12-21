//
//  CityListViewModelTest.swift
//  lab1
//
//  Created by witold on 15.12.2025.
//
 
@testable import lab1
import XCTest
@MainActor
final class CityListViewModelTests: XCTestCase {
    var sut: CityListViewModel!
    var mockRepository: MockCityRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCityRepository()
        sut = CityListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(sut.cities.isEmpty, "Cities should be empty initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        XCTAssertNil(sut.errorMessage, "Should have no error initially")
        XCTAssertTrue(sut.searchText.isEmpty, "Search text should be empty initially")
        XCTAssertEqual(sut.lastUpdate, "", "Last update should be empty initially")
    }
    
    func testRefreshCities_Success() async {
        let expectedCities = [
            City(name: "Kyiv", aqi: 45, pm25: 12.5, o3: 28.3),
            City(name: "Lviv", aqi: 30, pm25: 8.0, o3: 20.0)
        ]
        mockRepository.citiesToReturn = expectedCities
        
        await sut.refreshCities()
        
        XCTAssertEqual(mockRepository.refreshCallCount, 1, "Refresh should be called once")
        XCTAssertEqual(sut.cities.count, 2, "Should have 2 cities")
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
        XCTAssertNil(sut.errorMessage, "Should have no error on success")
        XCTAssertFalse(sut.lastUpdate.isEmpty, "Last update should be set")
    }
    
    func testRefreshCities_Failure() async {
        mockRepository.shouldFail = true
        
        await sut.refreshCities()
        
        XCTAssertEqual(mockRepository.refreshCallCount, 1)
        XCTAssertNotNil(sut.errorMessage, "Should have error message on failure")
        XCTAssertFalse(sut.isLoading, "Should not be loading after failure")
        XCTAssertTrue(sut.errorMessage!.contains("Failed to load cities"))
    }

    func testSearchCity_ValidInput() async {
        sut.searchText = "Warsaw"
        let city = City(name: "Warsaw", aqi: 35)
        mockRepository.citiesToReturn = [city]
        
        await sut.searchCity()
        
        XCTAssertEqual(mockRepository.searchCallCount, 1)
        XCTAssertEqual(mockRepository.getCitiesCallCount, 1)
        XCTAssertTrue(sut.searchText.isEmpty, "Search text should be cleared after success")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testSearchCity_EmptyInput() async {
        sut.searchText = "   "
        
        await sut.searchCity()
        
        XCTAssertEqual(mockRepository.searchCallCount, 0, "Should not call search with empty input")
        XCTAssertFalse(sut.isLoading)
    }
    
    func testSearchCity_Failure() async {
        sut.searchText = "InvalidCity"
        mockRepository.shouldFail = true
        
        await sut.searchCity()
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage!.contains("Failed to find city"))
    }

    func testClearAllCities_Success() async {
        sut.cities = [City(name: "Test", aqi: 50)]
        sut.lastUpdate = "Some date"
        
        await sut.clearAllCities()
        
        XCTAssertEqual(mockRepository.clearCallCount, 1)
        XCTAssertTrue(sut.cities.isEmpty)
        XCTAssertEqual(sut.lastUpdate, "None")
    }
    
    func testSortedCities_WithCurrentLocation() {
        let currentLocation = City(name: "Your location", aqi: 60)
        let subscribed = City(name: "Kyiv", aqi: 45, selected: true)
        let regular = City(name: "Warsaw", aqi: 30)
        
        sut.cities = [regular, subscribed, currentLocation]
        
        let sorted = sut.sortedCities
        
        XCTAssertEqual(sorted.count, 3)
        XCTAssertEqual(sorted[0].name, "Your location", "Current location should be first")
        XCTAssertEqual(sorted[1].name, "Kyiv", "Subscribed should be second")
        XCTAssertEqual(sorted[2].name, "Warsaw", "Regular should be last")
    }
    
    func testRefreshCities_CompletesSuccessfully() async {
        mockRepository.citiesToReturn = [City(name: "Kyiv", aqi: 45)]
        
        await sut.refreshCities()
        
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
        XCTAssertEqual(sut.cities.count, 1)
        XCTAssertNil(sut.errorMessage)
    }
}
