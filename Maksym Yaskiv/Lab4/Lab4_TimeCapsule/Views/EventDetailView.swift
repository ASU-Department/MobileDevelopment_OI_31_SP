//
//  EventDetailView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import SwiftData

struct EventDetailView: View {
    @StateObject private var viewModel: EventDetailViewModel
    
    @AppStorage("eventFontSize") private var fontSize: Double = 16.0
    @State private var isShowingSafari = false
    
    init(event: HistoricalEvent, repository: any TimeCapsuleRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: EventDetailViewModel(event: event, repository: repository))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text(viewModel.event.year)
                    .font(.largeTitle)
                    .bold()
                
                Text(viewModel.event.text)
                    .font(.system(size: fontSize))
                
                VStack(spacing: 15) {
                    if let url = URL(string: viewModel.event.urlString), !viewModel.event.urlString.isEmpty {
                        Button("Read Full Article") {
                            isShowingSafari = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    
                    Button(action: {
                        viewModel.toggleFavorite()
                    }) {
                        Label(
                            viewModel.event.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                            systemImage: viewModel.event.isFavorite ? "star.fill" : "star"
                        )
                    }
                    .buttonStyle(.bordered)
                    .tint(viewModel.event.isFavorite ? .orange : .blue)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingSafari) {
            if let url = URL(string: viewModel.event.urlString) {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}