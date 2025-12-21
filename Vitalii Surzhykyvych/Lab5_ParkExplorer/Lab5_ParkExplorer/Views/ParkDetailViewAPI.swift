//
//  ParkDetailViewAPI.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import SwiftUI
import MapKit

struct ParkDetailViewAPI: View {

    @StateObject private var viewModel: ParkDetailViewModel
    @Binding var favoriteParks: Set<String>

    init(park: ParkAPIModel, favoriteParks: Binding<Set<String>>) {
        self._favoriteParks = favoriteParks
        _viewModel = StateObject(wrappedValue: ParkDetailViewModel(park: park, favoriteParks: favoriteParks.wrappedValue))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.park.fullName)
                            .font(.largeTitle)
                            .bold()

                        Text(viewModel.park.states)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    FavoriteButton(
                        isFavorite: Binding(
                            get: { favoriteParks.contains(viewModel.park.id) },
                            set: { isFav in
                                if isFav {
                                    favoriteParks.insert(viewModel.park.id)
                                } else {
                                    favoriteParks.remove(viewModel.park.id)
                                }
                            }
                        ),
                        identifier: "favorite_detail_\(viewModel.park.id)"
                    )
                }

                Text(viewModel.park.description)
                    .font(.body)

                if let coordinate = viewModel.coordinate {
                    UIKitMapView(coordinate: coordinate)
                        .frame(height: 250)
                        .cornerRadius(12)
                }

                if let imageUrl = viewModel.park.images.first?.url {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Park Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
