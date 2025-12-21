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
        let isUITest = ProcessInfo.processInfo.arguments.contains("UI_TEST_MODE")

        if isUITest {
            let mockRepository = ParkRepositoryMock()
            mockRepository.parksToReturn = [
                ParkAPIModel(
                    id: "ui-test",
                    fullName: "UI Test Park",
                    states: "CA",
                    description: "Test park for UI tests",
                    latitude: nil,
                    longitude: nil,
                    images: []
                )
            ]

            _viewModel = StateObject(
                wrappedValue: ParkListViewModel(repository: mockRepository)
            )
        } else {
            let context = PersistenceController.shared.container.mainContext
            let storage = ParkStorageActor(context: context)
            let repository = ParkRepository(
                api: NPSService.shared,
                storage: storage
            )

            _viewModel = StateObject(
                wrappedValue: ParkListViewModel(repository: repository)
            )
        }
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
                                            if isFav {
                                                favoriteParks.insert(park.id)
                                            } else {
                                                favoriteParks.remove(park.id)
                                            }
                                        }
                                    ),
                                    identifier: "favorite_list_\(park.id)"
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
