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
    
    @State private var image: UIImage?
    @State private var showPicker = false

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
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                }

                Button("Add Park Photo") {
                    showPicker = true
                }
                .sheet(isPresented: $showPicker) {
                    ImagePicker(image: $image)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle(park.state)
        .navigationBarTitleDisplayMode(.inline)
    }
}
