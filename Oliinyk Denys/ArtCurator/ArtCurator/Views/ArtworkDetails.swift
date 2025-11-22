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
                AsyncImage(url: URL(string: artwork.primaryImage.isEmpty ? artwork.primaryImageSmall : artwork.primaryImage)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(.gray.opacity(0.3))
                            .frame(height: 300)
                            .overlay(
                                CustomIndicator(isAnimating: .constant(true), style: .large)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 400)
                            .cornerRadius(12)
                    case .failure:
                        Rectangle()
                            .fill(.gray.opacity(0.3))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "photo.artframe")
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
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
                        Text("Details")
                            .font(.headline)
                        
                        if !artwork.objectDate.isEmpty {
                            ArtworkDetailRow(label: "Date", value: artwork.objectDate)
                        }
                        
                        if !artwork.medium.isEmpty {
                            ArtworkDetailRow(label: "Medium", value: artwork.medium)
                        }
                        
                        if !artwork.department.isEmpty {
                            ArtworkDetailRow(label: "Department", value: artwork.department)
                        }
                        
                        ArtworkDetailRow(label: "Object ID", value: String(artwork.id))
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
        .navigationTitle("Artwork Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ArtworkDetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}
