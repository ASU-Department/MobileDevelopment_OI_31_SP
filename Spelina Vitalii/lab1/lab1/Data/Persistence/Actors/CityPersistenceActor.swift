//
//  CityPersistenceActor.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

import SwiftData
import Foundation

actor CityPersistenceActor {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchCity(byName name: String) throws -> City? {
        let predicate = #Predicate<City> { $0.name == name }
        let descriptor = FetchDescriptor<City>(predicate: predicate)
        return try modelContext.fetch(descriptor).first
    }
    
    func fetchAllCities() throws -> [City] {
        let descriptor = FetchDescriptor<City>(sortBy: [SortDescriptor(\City.name)])
        return try modelContext.fetch(descriptor)
    }
    
    func insertCity(_ city: City) throws {
        modelContext.insert(city)
        try modelContext.save()
    }
    
    func updateCity(_ city: City, with data: AQCoreData) throws {
        city.updateFromAPI(data)
        try modelContext.save()
    }
    
    func deleteAllCities() throws {
        let allCities = try fetchAllCities()
        allCities.forEach { modelContext.delete($0) }
        try modelContext.save()
    }
    
    func save() throws {
        try modelContext.save()
    }
}
