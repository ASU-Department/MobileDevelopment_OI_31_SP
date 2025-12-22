//
//  ContentView.swift
//  ParkExplorer
//
//  Created by Vitalik on 27.10.2025.
//

import SwiftUI
import MapKit
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel: ParkListViewModel

    @State private var searchText = ""

    init() {
        _viewModel = StateObject(
            wrappedValue: ParkListViewModel(
                modelContext: PersistenceController.shared.container.mainContext
            )
        )
    }

    private var filteredParks: [ParkAPIModel] {
        if searchText.isEmpty {
            viewModel.parks
        } else {
            viewModel.parks.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText) ||
                $0.states.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading parks...")
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            Task {
                                await loadParksAndUpdateLastUpdate()
                            }
                        }
                    }
                } else {
                    List(filteredParks) { park in
                        NavigationLink {
                            ParkDetailViewAPI(park: park)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(park.fullName)
                                    .font(.headline)
                                Text(park.states)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .refreshable {
                        await loadParksAndUpdateLastUpdate()
                    }
                }
            }
            .navigationTitle("National Parks")
            .searchable(text: $searchText)
            .task {
                await loadParksAndUpdateLastUpdate()
            }
        }
    }

    private func loadParksAndUpdateLastUpdate() async {
        await viewModel.loadParks()
        if viewModel.errorMessage == nil {
            // Зберігаємо дату останнього успішного оновлення
            UserSettings.lastUpdate = Date()
        }
    }
}

#Preview {
    ContentView()
}
