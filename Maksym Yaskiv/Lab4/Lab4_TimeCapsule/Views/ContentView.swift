//
//  ContentView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let repository: any TimeCapsuleRepositoryProtocol
    @StateObject private var viewModel: HomeViewModel
    
    @AppStorage("eventFontSize") private var eventFontSize: Double = 16.0
    @State private var showingError = false
    
    init(repository: any TimeCapsuleRepositoryProtocol) {
            self.repository = repository
            _viewModel = StateObject(wrappedValue: HomeViewModel(repository: repository))
        }

    var body: some View {
        TabView {
            NavigationStack {
                VStack {
                    DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .onChange(of: viewModel.selectedDate) {
                            Task { await viewModel.loadData() }
                        }
                    
                    if viewModel.isLoading {
                        ProgressView("Loading history...")
                            .padding()
                    }
                    
                    List {
                        if viewModel.events.isEmpty && !viewModel.isLoading {
                            ContentUnavailableView("No events found", systemImage: "clock")
                        }
                        
                        ForEach(viewModel.events) { event in
                            NavigationLink(value: event) {
                                HStack {
                                    Text(event.year).bold().foregroundStyle(.blue)
                                    Text(event.text)
                                        .font(.system(size: eventFontSize))
                                        .lineLimit(2)
                                    Spacer()
                                    if event.isFavorite {
                                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deleteEvent)
                    }
                    .refreshable {
                        await viewModel.loadData()
                    }
                }
                .navigationTitle("🕰️ TimeCapsule")
                .navigationDestination(for: HistoricalEvent.self) { event in
                    EventDetailView(event: event, repository: repository)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gear")
                        }
                    }
                }
            }
            .tabItem { Label("Events", systemImage: "calendar") }
            .onAppear {
                Task { await viewModel.loadData() }
            }

            FavoritesView(repository: repository)
                        .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
        .tint(.yellow)
        .alert("Error", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }
}