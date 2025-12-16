//
//  RootView.swift
//  lab1
//
//  Created by witold on 06.11.2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @StateObject private var coordinator: AppCoordinator
    
    init(modelContext: ModelContext) {
        _coordinator = StateObject(wrappedValue: AppCoordinator(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeRootView()
                .navigationDestination(for: City.self) { city in
                    coordinator.makeCityDetailsView(city: city)
                }
        }
    }
}
