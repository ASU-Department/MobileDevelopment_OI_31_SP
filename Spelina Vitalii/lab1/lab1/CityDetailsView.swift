//
//  CityDetailsView.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftUI

struct CityDetailView: View {
    @Binding var city: City
    @State private var isLoading = false
    @State private var message = ""

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

                Toggle("Subscribed", isOn: $city.selected)
                    .padding(.horizontal)

                LoadingView(isLoading: $isLoading)
                    .frame(width: 50, height: 50)
                    .padding(.top, 20)

                Button("Refresh Data") {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
                .padding(.top, 10)
                
                Divider()
                
                CityNoteController(note: $city.note)
                            .frame(height: 60)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)

            }
            .padding()
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CityDetailView_Previews: PreviewProvider {
    @State static var mockCity = City(
        name: "Kyiv",
        aqi: 82,
        pm25: 27.4,
        o3: 12.1,
        selected: true
    )

    static var previews: some View {
        NavigationStack {
            CityDetailView(city: $mockCity)
        }
    }
}
