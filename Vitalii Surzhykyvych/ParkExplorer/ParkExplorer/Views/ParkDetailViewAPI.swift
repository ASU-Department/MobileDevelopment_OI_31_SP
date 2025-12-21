//
//  ParkDetailViewAPI.swift
//  ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import SwiftUI
import MapKit

struct ParkDetailViewAPI: View {

    let park: ParkAPIModel
    @Binding var favoriteParks: Set<String>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                HStack {
                    VStack(alignment: .leading) {
                        Text(park.fullName)
                            .font(.largeTitle)
                            .bold()

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

                Text(park.description)
                    .font(.body)

                if
                    let lat = park.latitude,
                    let lon = park.longitude,
                    let latitude = Double(lat),
                    let longitude = Double(lon)
                {
                    UIKitMapView(
                        coordinate: CLLocationCoordinate2D(
                            latitude: latitude,
                            longitude: longitude
                        )
                    )
                    .frame(height: 250)
                    .cornerRadius(12)
                }

                if let imageUrl = park.images.first?.url {
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
