//
//  CityDetailsViewModelTest.swift
//  lab1Tests
//
//  Created by witold on 15.12.2025.
//

import Testing
@testable import lab1
@MainActor
@Suite("CityDetailViewModel Tests")
struct CityDetailViewModelTests {
    
    @Test("Initial state should match provided city")
    func testInitialState() async {
        let city = City(name: "Kyiv", aqi: 45, pm25: 12.5, o3: 28.3, selected: true)
        let mockRepo = MockCityRepository()
        
        let sut = CityDetailsViewModel(city: city, repository: mockRepo)
        
        #expect(sut.city.name == "Kyiv")
        #expect(sut.city.aqi == 45)
        #expect(sut.city.selected == true)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Refresh city data should update AQI values on success")
    func testRefreshCityData_Success() async {
        let city = City(name: "Kyiv", aqi: 45, pm25: 12.5, o3: 28.3)
        let mockRepo = MockCityRepository()
        mockRepo.aqiDataToReturn = AQCoreData(
            aqi: 60,
            iaqi: IAQI(pm25: AQValue(v: 18.0), o3: AQValue(v: 35.0))
        )
        let sut = CityDetailsViewModel(city: city, repository: mockRepo)
        
        await sut.refreshCityData()
        
        #expect(sut.city.aqi == 60)
        #expect(sut.city.pm25 == 18.0)
        #expect(sut.city.o3 == 35.0)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Refresh city data should set error message on failure")
    func testRefreshCityData_Failure() async {
        let city = City(name: "Kyiv", aqi: 45)
        let mockRepo = MockCityRepository()
        mockRepo.shouldFail = true
        let sut = CityDetailsViewModel(city: city, repository: mockRepo)
        
        await sut.refreshCityData()
        
        #expect(sut.errorMessage != nil)
        #expect(sut.isLoading == false)
    }
    
    @Test("Toggle subscription should update city selection")
    func testToggleSubscription_Success() async {
        let city = City(name: "Kyiv", aqi: 45, selected: false)
        let mockRepo = MockCityRepository()
        let sut = CityDetailsViewModel(city: city, repository: mockRepo)
        
        let initialSelection = sut.city.selected
        
        await sut.toggleSubscription()
        
        #expect(sut.city.selected != initialSelection)
        #expect(mockRepo.updateSubscriptionCallCount == 1)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Toggle subscription should rollback on failure")
    func testToggleSubscription_FailureRollback() async {
        let city = City(name: "Kyiv", aqi: 45, selected: false)
        let mockRepo = MockCityRepository()
        mockRepo.shouldFail = true
        let sut = CityDetailsViewModel(city: city, repository: mockRepo)
        
        let initialSelection = sut.city.selected
        
        await sut.toggleSubscription()
        
        #expect(sut.city.selected == initialSelection, "Should rollback to initial state")
        #expect(sut.errorMessage != nil)
        #expect(sut.errorMessage!.contains("Failed to update subscription"))
    }

    @Test("Loading state should be true during refresh")
    func testLoadingStateDuringRefresh() async {
        let city = City(name: "Kyiv", aqi: 45)
        let mockRepo = MockCityRepository()
        let sut = CityDetailsViewModel(city: city, repository: mockRepo)
        
        #expect(sut.isLoading == false, "Should not be loading initially")
        
        Task {
            await sut.refreshCityData()
        }
        
        try? await Task.sleep(nanoseconds: 10_000_000)
        
        #expect(sut.isLoading == false, "Should not be loading after completion")
    }
}
