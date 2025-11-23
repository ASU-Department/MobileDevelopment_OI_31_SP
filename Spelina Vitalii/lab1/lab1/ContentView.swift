//
//  ContentView.swift
//  lab1
//
//  Created by witold on 06.11.2025.
//

import SwiftUI
import _SwiftData_SwiftUI

struct ContentView: View {
    @Query(sort: [SortDescriptor(\City.name)], animation: .default) var cities: [City]
    var sortedCities: [City] {
        let curr = cities.first { $0.name == "Your location" }
        let subscribed = cities.filter { $0.selected && $0.name != "Your location" }
        let others = cities.filter { !$0.selected && $0.name != "Your location" }
        
        var result: [City] = []
        if let curr = curr {
            result.append(curr)
        }
        result.append(contentsOf: subscribed)
        result.append(contentsOf: others)
        return result
    }
    @Environment(\.modelContext) private var modelContext
    @StateObject private var service = CityService()
    @State private var isLoading = false
    @State private var searchText = ""
    @State private var errorMessage: String? = nil
    @AppStorage("lastUpdate") private var lastUpdate: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter city to add", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                    
                    Button("Search") {
                        Task {
                            await searchCity()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                Text("Last update: \(lastUpdate)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Group {
                    List(sortedCities, id: \.id) { city in
                        NavigationLink(destination: CityDetailView(city: city)) {
                            CityItemView(city: city)
                        }
                    }
                    .refreshable {
                        await refreshCities()
                    }
                    .overlay {
                        if isLoading {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .alert("Error occured while fetching data", isPresented: Binding(
                        get: { errorMessage != nil },
                        set: { if !$0 { errorMessage = nil } }
                    )) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(errorMessage ?? "")
                    }
                }
            }
            .navigationTitle("AirAware")
            .toolbar {
                Button {
                    service.clearAllCities(modelContext: modelContext)
                    lastUpdate = "None"
                } label: {
                    Image(systemName: "trash")
                }
            }
            .task {
                await refreshCities()
            }
        }
    }
    
    func refreshCities() async {
        isLoading = true
        do {
            try await service.refreshAllCities(modelContext: modelContext)
            lastUpdate = Date().formatted(date: .numeric, time: .shortened)

        } catch {
            errorMessage = "Failed to load cities. Showing local data."
        }
        isLoading = false
    }
    
    func searchCity() async {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        do {
            let apiData = try await service.fetchAQI(for: searchText)
            
            if let existing = try? modelContext.fetch(FetchDescriptor<City>(
                predicate: #Predicate { $0.name == searchText }
            )).first {
                existing.updateFromAPI(apiData)
            } else {
                let newCity = City.fromAPI(name: searchText, apiData)
                modelContext.insert(newCity)
            }
            
            try? modelContext.save()
        } catch {
            print("Failed loading city \(searchText): \(error)")
        }
        isLoading = false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        var body: some View {
            let mockCities: [City] = [
                City(name: "Kyiv", aqi: 82, pm25: 27.4, o3: 12.1, selected: true),
                City(name: "Lviv", aqi: 42, pm25: 14.2, o3: 6.0),
                City(name: "Odesa", aqi: 118, pm25: 35.1, o3: 17.3)
            ]
            
            let container: ModelContainer = try! ModelContainer(for: City.self)
            let context: ModelContext = container.mainContext
            mockCities.forEach { context.insert($0) }

            return ContentView()
                .environment(\.modelContext, context)
                .modelContainer(container)
        }
    }
}

