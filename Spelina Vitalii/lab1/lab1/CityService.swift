//
//  CityStore.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftUI
import Combine
import SwiftData

@MainActor
final class CityService: ObservableObject {

    let token = "04839fd87e593b3fa853a64eb67b964beadaf778"

    let defaultCities = [
        "Your location", //nearest
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

    func refreshAllCities(modelContext: ModelContext) async throws {
        var firstError: Error?
        
        for name in defaultCities {
            do {
                let apiData = try await fetchAQI(for: name == "Your location" ? "here" : name)
                
                if let existing = try? modelContext.fetch(FetchDescriptor<City>(
                    predicate: #Predicate { $0.name == name }
                )).first {
                    existing.updateFromAPI(apiData)
                } else {
                    let newCity = City.fromAPI(name: name, apiData)
                    modelContext.insert(newCity)
                }
                
                try? modelContext.save()

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

    func fetchAQI(for city: String) async throws -> AQCoreData {
        let url = URL(string: "https://api.waqi.info/feed/\(city)/?token=\(token)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(AQResponse.self, from: data)

        guard decoded.status == "ok", let core = decoded.data else {
            throw URLError(.badServerResponse)
        }
        
        return core
    }
    
    func clearAllCities(modelContext: ModelContext) {
        do {
            let allCities = try modelContext.fetch(FetchDescriptor<City>())
            allCities.forEach { modelContext.delete($0) }
            try modelContext.save()
            print("All cities cleared.")
        } catch {
            print("Failed to clear cities: \(error)")
        }
    }
}

