//
//  WeatherDetailView.swift
//  WeatherWise
//
//  Created by vburdyk on 15.12.2025.
//

import SwiftUI
import SwiftData

struct WeatherDetailView: View {
    
    let city: String
    
    @State private var mapScale: Double = 0.5
    @StateObject private var viewModel = WeatherViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Місто: \(city)")
                .font(.title2)
            
            MapViewRepresentable(cityName: city, scale: mapScale)
                .frame(height: 250)
                .cornerRadius(10)
            
            MapScaleController(scale: $mapScale)
                .frame(height: 120)
            
            Text("Масштаб карти: \(String(format: "%.2f", mapScale))")
                .foregroundColor(.gray)
                .font(.caption)
            
            Button("Завантажити погоду") {
                viewModel.loadWeather(for: city, context: modelContext)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            if viewModel.isLoading {
                ProgressView("Завантаження...")
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            if let temp = viewModel.temperature {
                Text("Температура: \(temp, specifier: "%.1f")°C")
                    .font(.headline)
            }
            
            if let wind = viewModel.wind {
                Text("Вітер: \(wind, specifier: "%.1f") m/s")
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Карта міста")
    }
}

