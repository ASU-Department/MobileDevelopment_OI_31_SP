//
//  CityStore.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftUI
import Combine

class CityStore: ObservableObject {
    @Published var cities: [City] = []

    func loadMockData() {
        cities = [
            City(name: "Kyiv", aqi: 82,  pm25: 27.4, o3: 12.1),
            City(name: "Lviv", aqi: 42,  pm25: 14.2, o3:  6.0),
            City(name: "Odesa", aqi: 118, pm25: 35.1, o3: 17.3),
            City(name: "Dnipro", aqi: 156, pm25: 48.9, o3: 21.5),
            City(name: "Kharkiv", aqi: 203, pm25: 60.4, o3: 30.1),
            City(name: "Warsaw", aqi: 55,  pm25: 18.0, o3: 10.0),
            City(name: "Krakow", aqi: 65,  pm25: 21.5, o3:  8.7),
            City(name: "New York", aqi: 91,  pm25: 22.8, o3: 16.4),
            City(name: "Tokyo", aqi: 47,  pm25: 13.2, o3:  5.4),
            City(name: "New Delhi", aqi: 289, pm25: 120.7, o3: 33.0)
        ]
    }
}
