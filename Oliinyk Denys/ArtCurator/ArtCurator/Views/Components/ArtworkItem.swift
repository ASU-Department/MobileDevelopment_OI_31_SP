//
//  ArtworkItem.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import SwiftUI

struct ArtworkItem: View {
    @Binding var artwork: Artwork
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: artwork.primaryImageSmall)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            CustomIndicator(isAnimating: .constant(true), style: .medium)
                        )
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                case .failure:
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "photo.artframe")
                                .foregroundColor(.gray)
                                .font(.system(size: 24))
                        )
                @unknown default:
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                }
            }
            .cornerRadius(8)
            .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(artwork.artistDisplayName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                if !artwork.objectDate.isEmpty {
                    Text(artwork.objectDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Button(action: { artwork.isFavorite.toggle() }) {
                Image(systemName: artwork.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(artwork.isFavorite ? .red : .gray)
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
}
