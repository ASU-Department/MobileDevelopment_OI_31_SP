//
//  CityDetailsView.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

import SwiftUI

struct CityDetailsView: View {
    @ObservedObject var viewModel: CityDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(viewModel.city.name)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                VStack(spacing: 8) {
                    Text("Air Quality Index")
                        .font(.headline)
                    Text("\(viewModel.city.aqi)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(viewModel.city.color)
                    Text(viewModel.city.healthAdvice)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Divider().padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("PM2.5:")
                        Spacer()
                        Text(String(format: "%.1f µg/m³", viewModel.city.pm25))
                            .font(.headline)
                    }
                    HStack {
                        Text("O3:")
                        Spacer()
                        Text(String(format: "%.1f ppb", viewModel.city.o3))
                            .font(.headline)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                Divider()
                
                Toggle("Subscribe", isOn: Binding(
                    get: { viewModel.city.selected },
                    set: { _ in
                        Task {
                            await viewModel.toggleSubscription()
                        }
                    }
                ))
                .padding(.horizontal)
                
                LoadingView(isLoading: $viewModel.isLoading)
                    .frame(width: 50, height: 50)
                    .padding(.top, 20)
                
                Button("Refresh Data") {
                    Task {
                        await viewModel.refreshCityData()
                    }
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle(viewModel.city.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error occurred while fetching data",
               isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
               )
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
