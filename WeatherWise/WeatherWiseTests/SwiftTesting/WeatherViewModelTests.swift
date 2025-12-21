//
//  WeatherViewModelTests.swift
//  WeatherWise
//
//  Created by vburdyk on 17.12.2025.
//

@testable import WeatherWise
import Testing
import Foundation

@MainActor
struct WeatherViewModelTests {

    @Test
    func loadWeatherSuccess() async throws {
        let repo = MockWeatherRepository()
        repo.result = .success(20.0, 5.0)

        let vm = WeatherViewModel(repository: repo)

        await vm.loadWeather(for: "Львів")

        #expect(vm.temperature == 20.0)
        #expect(vm.wind == 5.0)
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }

    @Test
    func loadWeatherFailure() async {
        let repo = MockWeatherRepository()
        repo.result = .failure(URLError(.notConnectedToInternet))

        let vm = WeatherViewModel(repository: repo)

        await vm.loadWeather(for: "Львів")

        #expect(vm.temperature == nil)
        #expect(vm.errorMessage != nil)
    }
}
