//
//  ArtworkDetails.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 08.11.2025.
//

import SwiftUI

struct ArtworkDetails: View {
    @Binding var artwork: Artwork
    @State private var showShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Rectangle()
                    .fill(.blue.opacity(0.3))
                    .frame(height: 300)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "photo.artframe")
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.7))
                    )
                    .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(artwork.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: { artwork.isFavorite.toggle() }) {
                            Image(systemName: artwork.isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(artwork.isFavorite ? .red : .gray)
                        }
                    }
                    
                    Text(artwork.artistDisplayName)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Loading Info")
                            .font(.headline)
                        
                        HStack {
                            ActivityIndicator(isAnimating: .constant(true), style: .medium)
                            Text("Fetching details...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    Button(action: { showShareSheet = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheetRepresentable(items: [
                            "\(artwork.title) by \(artwork.artistDisplayName)"
                        ])
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(artwork.title) details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
