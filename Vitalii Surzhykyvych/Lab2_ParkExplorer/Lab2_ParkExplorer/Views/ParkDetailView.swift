//
//  ParkDetailView.swift
//  Lab2_ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import SwiftUI
import MapKit

struct ParkDetailView: View {
    @Binding var park: Park

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                HStack {
                    Text(park.name)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    FavoriteButton(isFavorite: $park.isFavorite)
                }

                Text(park.description)

                UIKitMapView(coordinate: park.coordinate)
                    .frame(height: 250)
                    .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle(park.state)
        .navigationBarTitleDisplayMode(.inline)
    }
}
