//
//  CityRepository.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

protocol CityRepositoryProtocol {
    func fetchAQI(for cityName: String) async throws -> AQCoreData
    func refreshAllCities() async throws
    func searchAndAddCity(name: String) async throws
    func clearAllCities() async throws
    func updateCitySubscription(city: City, isSelected: Bool) async throws
    func getCities() async throws -> [City]
}
