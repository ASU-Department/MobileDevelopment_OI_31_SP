//
//  ParkDetailViewAPI.swift
//  Lab3_ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import SwiftUI
import MapKit

struct ParkDetailViewAPI: View {

    let park: ParkAPIModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Text(park.fullName)
                    .font(.largeTitle)
                    .bold()

                Text(park.states)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

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
