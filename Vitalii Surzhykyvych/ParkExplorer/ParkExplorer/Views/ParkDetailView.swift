//
//  ParkDetailView.swift
//  ParkExplorer
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
                
                if let selectedImage = image {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)

                    HStack {
                        Button {
                            showPicker = true
                        } label: {
                            Label("Replace Photo", systemImage: "arrow.triangle.2.circlepath")
                        }

                        Spacer()

                        Button(role: .destructive) {
                            ImageStorage.deleteImage(for: park.id)
                            image = nil
                        } label: {
                            Label("Delete Photo", systemImage: "trash")
                        }
                    }
                } else {
                    Button {
                        showPicker = true
                    } label: {
                        Label("Add Park Photo", systemImage: "photo")
                    }
                }
            }
            .padding()
        }
        .onAppear {
            image = ImageStorage.loadImage(for: park.id)
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $image)
                .onDisappear {
                    if let image = image {
                        ImageStorage.saveImage(image, for: park.id)
                    }
                }
        }
        .navigationTitle(park.state)
        .navigationBarTitleDisplayMode(.inline)
    }
}
