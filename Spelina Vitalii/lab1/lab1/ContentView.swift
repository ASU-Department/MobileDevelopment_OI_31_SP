//
//  ContentView.swift
//  lab1
//
//  Created by witold on 06.11.2025.
//

import SwiftUI

struct City: Identifiable {
    let id = UUID()
    let name: String
    let polLevel: Float
    var selected: Bool = false
}

struct ContentView: View {
    
    @State private var cities = [
        City(name: "Kyiv", polLevel: 3.1),
        City(name: "Lviv", polLevel: 2.6),
        City(name: "Chernihiv", polLevel: 2.7),
        City(name: "Vinnytsia", polLevel: 2.1),
        City(name: "Ternopil", polLevel: 3.0),
        City(name: "Warsaw", polLevel: 1.6),
        City(name: "Krakow", polLevel: 1.8),
        City(name: "London", polLevel: 2.1),
        City(name: "New York", polLevel: 2.3),
        City(name: "Los Angeles", polLevel: 1.9),
        City(name: "Tokyo", polLevel: 1.8),
        City(name: "Shanghai", polLevel: 1.6),
        City(name: "New Dehli", polLevel: 5.7),
        City(name: "Kairo", polLevel: 3.0)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach($cities) { $city in
                    CityItemView(city: $city)
                }
            }
            .navigationTitle("Subscribe")
        }
    }
}

#Preview {
    ContentView()
}
