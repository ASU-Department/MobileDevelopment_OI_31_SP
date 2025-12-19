//
//  ContentView.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import SwiftUI
import MapKit
import SwiftData

struct ContentView: View {

    @StateObject private var viewModel: ParkListViewModel
    @State private var searchText = ""
    @State private var favoriteParks: Set<String> = []

    init() {
        let context = PersistenceController.shared.container.mainContext
        let storage = ParkStorageActor(context: context)
        let repository = ParkRepository(api: NPSService.shared, storage: storage)

        _viewModel = StateObject(
            wrappedValue: ParkListViewModel(repository: repository)
        )
    }

    private var filteredParks: [ParkAPIModel] {
        if searchText.isEmpty {
            return viewModel.parks
        } else {
            return viewModel.parks.filter {
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
                                await viewModel.loadParks()
                            }
                        }
                    }
                } else {
                    List(filteredParks) { park in
                        NavigationLink {
                            ParkDetailViewAPI(
                                park: park,
                                favoriteParks: $favoriteParks
                            )
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(park.fullName)
                                        .font(.headline)
                                    Text(park.states)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                FavoriteButton(
                                    isFavorite: Binding(
                                        get: { favoriteParks.contains(park.id) },
                                        set: { isFav in
                                            if isFav { favoriteParks.insert(park.id) }
                                            else { favoriteParks.remove(park.id) }
                                        }
                                    )
                                )
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.loadParks()
                    }
                }
            }
            .navigationTitle("National Parks")
            .searchable(text: $searchText)
            .toolbar {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
            .task {
                await viewModel.loadParks()
            }
        }
    }
}

#Preview {
    ContentView()
}
