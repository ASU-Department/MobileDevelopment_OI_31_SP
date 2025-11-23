//
//  CityDetailsView.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftUI
import SwiftData

struct CityDetailView: View {
    @Bindable var city: City
    @Environment(\.modelContext) private var modelContext
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(city.name)
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                VStack(spacing: 8) {
                    Text("Air Quality Index")
                        .font(.headline)

                    Text("\(city.aqi)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(city.color)

                    Text(city.healthAdvice)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Divider().padding(.vertical, 10)

                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("PM2.5:")
                        Spacer()
                        Text(String(format: "%.1f µg/m³", city.pm25))
                            .font(.headline)
                    }

                    HStack {
                        Text("O3:")
                        Spacer()
                        Text(String(format: "%.1f ppb", city.o3))
                            .font(.headline)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                Divider()

                Toggle("Subscribe", isOn: $city.selected)
                    .padding(.horizontal)
                    .onChange(of: city.selected) {
                        do {
                            try modelContext.save()
                        } catch {
                            print("Failed saving toggle: \(error)")
                        }
                    }

                LoadingView(isLoading: $isLoading)
                    .frame(width: 50, height: 50)
                    .padding(.top, 20)

                Button("Refresh Data") {
                    Task {
                        await refreshCityData()
                    }
                }
                .padding(.top, 10)

            }
            .padding()
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error occurred while fetching data",
               isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
               )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    func refreshCityData() async {
        isLoading = true
        do {
            let service = CityService()
            let apiData = try await service.fetchAQI(for: city.name)
            city.updateFromAPI(apiData)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

