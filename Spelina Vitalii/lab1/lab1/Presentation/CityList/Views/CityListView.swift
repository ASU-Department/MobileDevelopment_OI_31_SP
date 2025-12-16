//
//  CityListView.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

import SwiftUI
import _SwiftData_SwiftUI

struct CityListView: View {
    @StateObject var viewModel: CityListViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\City.name)], animation: .default) var cities: [City]
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter city to add", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                
                Button("Search") {
                    Task {
                        await viewModel.searchCity()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            .padding(.top, 5)
            
            Text("Last update: \(viewModel.lastUpdate)")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            List(viewModel.sortedCities, id: \.id) { city in
                Button {
                    viewModel.navigateToCityDetail(city)
                } label: {
                    CityItemView(city: city)
                }
            }
            .refreshable {
                await viewModel.refreshCities()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .alert("Error occurred while fetching data", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .navigationTitle("AirAware")
        .toolbar {
            Button {
                Task {
                    await viewModel.clearAllCities()
                }
            } label: {
                Image(systemName: "trash")
            }
        }
        .task {
            await viewModel.loadCities()
            await viewModel.refreshCities()
        }
        .onChange(of: cities) { _, newValue in
            viewModel.cities = newValue
        }
    }
}
