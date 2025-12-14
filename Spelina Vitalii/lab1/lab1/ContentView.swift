//
//  ContentView.swift
//  lab1
//
//  Created by witold on 06.11.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cityStore: CityStore
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($cityStore.cities) { $city in
                    NavigationLink(destination: CityDetailView(city: $city)) {
                        CityItemView(city: $city)
                    }
                }
            }
            .navigationTitle("AirAware")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let store = CityStore()
        store.loadMockData()
        return ContentView()
            .environmentObject(store)
    }
}

